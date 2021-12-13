//
//  LogicalOperator.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol Operator: CardRepresentable {
    var type: OperatorType { get }
    var id: UUID { get }
}

extension Operator {
    var iconName: String? {
        nil
    }
    
    var color: Color {
        type.color
    }
    
    var description: String {
        type.description
    }
}

struct Or: CardRepresentable, Operator {
    let id: UUID = .init()
    var type = OperatorType.or

    var entities: [TextEntity] {
        [TextEntity(text: "or")]
    }
}

struct And: CardRepresentable, Operator {
    let id: UUID = .init()
    var type = OperatorType.and
    
    var entities: [TextEntity] {
        [TextEntity(text: "and")]
    }
}


enum OperatorType: String, CaseIterable {
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
    
    var iconName: String? {
        nil
    }
}
