//
//  TextEntity.swift
//  Woof
//
//  Created by Mike Choi on 12/13/21.
//

import SwiftUI

enum EditAction {
    case cryptoType, cryptoAmount, wallet
    case comparator
    case percentage
    case email
    case staticText
    
    var placeholder: String {
        switch self {
            case .cryptoType:
                return "Select crypto"
            case .cryptoAmount:
                return "Crypto amount"
            case .wallet:
                return "Select wallet"
            case .comparator:
                return "Comparator"
            case .percentage:
                return "Percentage"
            case .email:
                return "Email"
            default:
                return ""
        }
    }
}

protocol CardProperty {
    var id: UUID { get }
    var action: EditAction { get }
    var description: String? { get }
}

// MARK: -

struct StaticText: CardProperty {
    let id = UUID()
    let action: EditAction = .staticText
    let text: String
    
    var description: String? {
        text
    }
}

struct CryptoTypeProperty: CardProperty {
    let id = UUID()
    let cryptoSymbol: String?
    let action: EditAction = .cryptoType
    
    var description: String? {
        cryptoSymbol?.capitalized
    }
}

struct CryptoAmountProperty: CardProperty {
    let id = UUID()
    let cryptoSymbol: String?
    let amount: Double?
    let action: EditAction = .cryptoAmount
    
    var description: String? {
        if let price = amount?.price {
            return "\(price)\(cryptoSymbol ?? "")"
        } else {
            return nil
        }
    }
}

struct WalletEntityProperty: CardProperty {
    let id = UUID()
    let wallet: Wallet?
    let action: EditAction = .wallet
    
    var description: String? {
        wallet?.name
    }
}

struct ComparatorProperty: CardProperty {
    let id = UUID()
    var value: Comparator?
    let action: EditAction = .comparator
    
    var description: String? {
        value?.actionDescription
    }
}

struct PercentageProperty: CardProperty {
    let id = UUID()
    var percentage: Double?
    let action: EditAction = .percentage
    
    var description: String? {
        percentage?.percentage
    }
}

struct EmailProperty: CardProperty {
    let id = UUID()
    var email: String?
    let action: EditAction = .email
    
    var description: String? {
        email
    }
}

