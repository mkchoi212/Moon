//
//  ComposerViewModel.swift
//  Woof
//
//  Created by Mike Choi on 12/11/21.
//

import Foundation
import SwiftUI

final class ComposerViewModel: ObservableObject {
    var original: Automation = .empty
    
    @Published var name: String = ""
    @Published var iconName = "moon.fill"
    @Published var iconColor: Color = .blue
    @Published var conditions: [CardRepresentable] = []
    @Published var actions: [CardRepresentable] = []
   
    init(automation: Automation) {
        self.original = automation
        
        name = automation.title
        iconColor = automation.color
        iconName = automation.iconName
        conditions = automation.conditions.map(AnyEquatableCondition.init)
        actions = automation.actions.map(AnyEquatableAction.init)
    }
    
    func hasChanges() -> Bool {
        !(original.title == name &&
        original.iconName == iconName &&
        original.color == iconColor &&
        original.conditions == conditions.compactMap { $0 as? Condition }.map(AnyEquatableCondition.init) &&
        original.actions == actions.compactMap { $0 as? Action }.map(AnyEquatableAction.init))
    }
    
    func addCondition(_ condition: ConditionType) {
        conditions.append(AnyEquatableCondition(condition: condition.makeEntity()))
    }
}
