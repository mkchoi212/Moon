//
//  EditorSheetViewModel.swift
//  Woof
//
//  Created by Mike Choi on 12/17/21.
//

import Foundation
import SwiftUI

final class EditorSheetViewModel: ObservableObject {
    @Published var viewModel = CoinViewModel()
    @Published var selectedAction: CardRepresentable?
    @Published var selectedEntity: TextEntity? {
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
    
    func editor(for entity: TextEntity) -> AnyView {
        switch entity.action {
            case .comparator(_):
                return AnyView(ComparatorEditor(entity: entity))
            case .percentage(let percentage):
                return AnyView(PercentageEditor(percentage: percentage))
            case .cryptoType(let cryptoSymbol):
                viewModel.fetchCoinData()
                return AnyView(CoinSelector(selectedCryptoSymbol: cryptoSymbol)
                                .environmentObject(viewModel))
            default:
                return AnyView(EmptyView())
        }
    }
    
    func detents(for entity: TextEntity?) -> [UISheetPresentationController.Detent] {
        guard let entity = entity else {
            return []
        }

        switch entity.action {
            case .comparator(_):
                return [.medium()]
            default:
                return [.medium(), .large()]
        }
    }
}
