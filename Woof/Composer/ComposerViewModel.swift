//
//  ComposerViewModel.swift
//  Woof
//
//  Created by Mike Choi on 12/11/21.
//

import CoreData
import SwiftUI

final class ComposerViewModel: ObservableObject {
    var original: Automation = .empty
    
    @Published var name: String = ""
    @Published var iconName = "moon.fill"
    @Published var iconColor: Color = .blue
    @Published var conditions: [CardRepresentable] = []
    @Published var actions: [CardRepresentable] = []
   
    var equatableConditions: [AnyEquatableCondition] {
        conditions.compactMap { $0 as? Condition }.map(AnyEquatableCondition.init)
    }
    
    var equatableActions: [AnyEquatableAction] {
        actions.compactMap { $0 as? Action }.map(AnyEquatableAction.init)
    }
    
    var newAutomation: Automation {
        Automation(id: original.id,
                   title: "foo",
                   color: iconColor,
                   iconName: iconName,
                   conditions: equatableConditions,
                   actions: equatableActions)
    }
    
    init(automation: Automation) {
        self.original = automation
        
        name = automation.title
        iconColor = automation.color
        iconName = automation.iconName
        conditions = automation.conditions.map(AnyEquatableCondition.init)
        actions = automation.actions.map(AnyEquatableAction.init)
    }

    func addCondition(_ condition: ConditionType) {
        conditions.append(AnyEquatableCondition(condition: condition.makeEntity()))
    }
}
