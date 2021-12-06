//
//  LogicalOperator.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol OperatorRepresentable { }

struct Or: CardRepresentable, OperatorRepresentable {
    let id: UUID = .init()
    var type: TypeRepresentable = LogicalOperator.or
    
    var description: Text {
        Text("or")
    }
}

struct And: CardRepresentable, OperatorRepresentable {
    let id: UUID = .init()
    var type: TypeRepresentable = LogicalOperator.and
    
    var description: Text {
        Text("and")
    }
}


enum LogicalOperator: String, TypeRepresentable, CaseIterable {
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
    
    var icon: Image? {
        nil
    }
}
