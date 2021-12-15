//
//  Action+CoreData.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import Foundation

extension ActionEntity {
    var action: Action? {
        guard let typeRawValue = type,
              let type = ActionType(rawValue: typeRawValue) else {
                  return nil
              }
        
        print(type)
        return nil
    }
}
