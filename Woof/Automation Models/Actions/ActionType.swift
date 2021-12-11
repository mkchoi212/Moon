//
//  Action.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol Action: CardRepresentable {
    var type: TypeRepresentable { get }
    func isEqualTo(_ other: Action) -> Bool
}

extension Action where Self: Equatable {
    func isEqualTo(_ other: Action) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}

struct AnyEquatableAction: Action {
    let action: Action
    
    var id: UUID {
        action.id
    }
    
    var description: Text {
        action.description
    }
    
    var type: TypeRepresentable {
        action.type
    }
    
    func isEqualTo(_ other: Action) -> Bool {
        action.isEqualTo(other)
    }
}

extension AnyEquatableAction: Equatable {
    static func ==(lhs: AnyEquatableAction, rhs: AnyEquatableAction) -> Bool {
        return lhs.action.isEqualTo(rhs.action)
    }
}


enum ActionType: TypeRepresentable {
    case notification
    case text
    case email
    case buy
    case sell
    case transfer
    case swap
    
    var iconName: String? {
        switch self {
            case .notification:
                return "bell.badge.fill"
            case .text:
                return "message.fill"
            case .email:
                return "envelope.fill"
            case .buy:
                return "cart.fill"
            case .sell:
                return "sparkle"
            case .transfer:
                return "arrow.left"
            case .swap:
                return "arrow.left.arrow.right"
        }
    }
    
    var color: Color {
        switch self {
            case .notification:
                return .red
            case .text:
                return .green
            case .email:
                return Color(uiColor: .lightGray)
            case .buy:
                return .blue
            case .sell:
                return .green
            case .transfer:
                return .mint
            case .swap:
                return .cyan
        }
    }
    
    var description: String {
        switch self {
            case .notification:
                return "Send notification"
            case .text:
                return "Text message"
            case .email:
                return "Email"
            case .buy:
                return "Buy"
            case .sell:
                return "Sell"
            case .transfer:
                return "Transfer"
            case .swap:
                return "Swap"
        }
    }
}
