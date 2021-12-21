//
//  EditorSheetViewModel.swift
//  Woof
//
//  Created by Mike Choi on 12/17/21.
//

import Foundation
import SwiftUI

final class EditorSheetViewModel: ObservableObject {
    @Published var viewModel = CoinViewModel.shared
    @Published var selectedAction: CardRepresentable?
    @Published var selectedProperty: CardProperty? {
        willSet {
            if let newValue = newValue {
                detents = detents(for: newValue)
            }
        }
    }
    @Published var detents: [UISheetPresentationController.Detent] = [.medium()]
    @Published var actionViewModels: [UUID : ActionViewModel] = [:]
    
    func setActions(actions: [CardRepresentable]) {
        actions.forEach { action in
            actionViewModels[action.id] = ActionViewModel(action: action)
        }
    }
    
    func actionViewModel(for action: CardRepresentable) -> ActionViewModel {
        if let vm = actionViewModels[action.id] {
            return vm
        } else {
            let newVM = ActionViewModel(action: action)
            actionViewModels[action.id] = newVM
            return newVM
        }
    }
    
    func editor(for entity: CardProperty) -> AnyView {
        switch entity.action {
            case .wallet:
                return AnyView(WalletSelector())
            case .comparator:
                return AnyView(ComparatorEditor(property: entity as! ComparatorProperty))
            case .percentage:
                return AnyView(PercentageEditor(property: entity as! PercentageProperty))
            case .cryptoType:
                viewModel.fetchCoinData()
                return AnyView(CoinSelector(property: entity as! CryptoTypeProperty)
                                .environmentObject(viewModel))
            default:
                return AnyView(EmptyView())
        }
    }
    
    func detents(for entity: CardProperty?) -> [UISheetPresentationController.Detent] {
        guard let entity = entity else {
            return []
        }

        switch entity.action {
            case .comparator:
                return [.medium()]
            default:
                return [.medium(), .large()]
        }
    }
}
