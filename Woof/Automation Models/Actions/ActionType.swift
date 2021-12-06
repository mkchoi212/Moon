//
//  Action.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol Action {
    var type: TypeRepresentable { get }
}

enum ActionType: TypeRepresentable {
    case notification
    case text
    case email
    case buy
    case sell
    case transfer
    case swap
    
    var icon: Image? {
        switch self {
            case .notification:
                return Image(systemName: "bell.badge.fill")
            case .text:
                return Image(systemName: "message.fill")
            case .email:
                return Image(systemName: "envelope.fill")
            case .buy:
                return Image(systemName: "cart.fill")
            case .sell:
                return Image(systemName: "sparkle")
            case .transfer:
                return Image(systemName: "arrow.left")
            case .swap:
                return Image(systemName: "arrow.left.arrow.right")
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
