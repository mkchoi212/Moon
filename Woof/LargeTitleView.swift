//
//  LargeTitleView.swift
//  Mosaic
//
//  Created by Johnny Appleseed on 11/16/19.
//  Copyright © 2019 435. All rights reserved.
//

import UIKit
import Network
import Combine

final class LargeTitleView: UIStackView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .bold)
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.text = title
        return label
    }()
    
    lazy var subtitleLabel: UILabel? = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 19).isActive = true
        return label
    }()
    
    lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, rightButton].compactMap { $0 })
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()

    let viewModel = TitleViewModel()
    
    var title: String
    var rightButton: UIButton?
    
    var isShowingUpdateText = false
    var streams = Set<AnyCancellable>()
    
    init(title: String, showSubtitle: Bool, rightButton: UIButton?) {
        self.title = title
        self.rightButton = rightButton
        
        super.init(frame: .zero)
        commonInit()
        listenToUpdateState()
        
        if showSubtitle {
            let didBecomeActive = NotificationCenter.default.publisher(for: .init("sceneDidBecomeActive")).map { _ in true }
            Just<Bool>(true).merge(with: didBecomeActive).receive(on: RunLoop.main).sink { [weak self] _ in
                self?.subtitleLabel?.text = self?.viewModel.normalTitleText()
            }.store(in: &streams)
            
            listenToLockedApp()
        } else {
            subtitleLabel?.isHidden = true
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("Init with coder is not supported")
    }
    
    private func commonInit() {
        axis = .vertical
        alignment = .fill
        spacing = 4
        
        [subtitleLabel, titleStackView].compactMap { $0 }.forEach {
            addArrangedSubview($0)
        }
    }
}

extension LargeTitleView {
    func setNormalTitleState(isUnlocked: Bool) {
        subtitleLabel?.text = viewModel.normalTitleText(isUnlocked: isUnlocked)
    }
    
    func listenToLockedApp() {
        if UserDefaultsConfig.isDemo {
            return
        }
        
        MOStore.shared.$isUnlocked.compactMap { $0 }.receive(on: RunLoop.main).sink { [weak self] in
            self?.setNormalTitleState(isUnlocked: $0)
        }.store(in: &streams)
    }
    
    func listenToUpdateState() {
        MOStorage.shared.state.$isFetchingUpdates.removeDuplicates()
            .throttle(for: 0.3, scheduler: RunLoop.main, latest: true)
            .receive(on: RunLoop.main)
            .sink { isUpdating in
                if self.isShowingUpdateText == isUpdating {
                    return
                }
                
                self.isShowingUpdateText = isUpdating
                self.titleLabel.pushTransition(0.2, scrollToTop: isUpdating)
                
                if isUpdating {
                    self.titleLabel.text = "Updating"
                } else {
                    self.titleLabel.text = self.title
                }
            }.store(in: &streams)
    }
}

extension UIView {
    func pushTransition(_ duration:CFTimeInterval, scrollToTop: Bool) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animation.type = .push
        animation.subtype = scrollToTop ? .fromTop : .fromBottom
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
}
