//
//  Condition+CoreData.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import Foundation

extension ConditionEntity {
    var condition: Condition? {
        guard let typeRawValue = type,
              let type = ConditionType(rawValue: typeRawValue) else {
                  return nil
              }
        
        print(type)
        return nil
    }
}

