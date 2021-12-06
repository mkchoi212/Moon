//
//  LogicalOperator.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

enum LogicalOperator: String, CaseIterable, ConditionDisplayable {
    case and, or
    
    var description: String {
        rawValue.uppercased()
    }
    
    var id: String {
        String(hashValue)
    }
    
    var color: Color {
        Color(uiColor: .lightGray)
    }
}
