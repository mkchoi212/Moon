//
//  Automation+CoreData.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import CoreData
import SwiftUI

extension AutomationContract {
    var automation: Automation {
        let parsedConditions = conditions?
            .compactMap { $0 as? ConditionEntity }
            .compactMap(\.condition)
            .map(AnyEquatableCondition.init)
        
        let parsedActions = actions?
            .compactMap { $0 as? ActionEntity }
            .compactMap(\.action)
            .compactMap(AnyEquatableAction.init)
        
        return Automation(id: id ?? UUID(),
                          title: title ?? "",
                          color: Color.deserialized(from: color) ?? .blue,
                          iconName: iconName ?? "moon.fill",
                          conditions: parsedConditions ?? [],
                          actions: parsedActions ?? [])
    }
}

// MARK: -

extension Automation {
    func coreDataModel(with context: NSManagedObjectContext) -> AutomationContract {
        let automation = AutomationContract(context: context)
        automation.color = color.data
        automation.date = Date()
        automation.iconName = iconName
        automation.id = id
        automation.title = title
        
        let actions = actions.map(\.action)
        return automation
    }
}
