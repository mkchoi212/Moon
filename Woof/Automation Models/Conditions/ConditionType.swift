//
//  Condition.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol Condition: CardRepresentable {
    var type: ConditionType { get }
    func isEqualTo(_ other: Condition) -> Bool
}

extension Condition where Self: Equatable {
    func isEqualTo(_ other: Condition) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}

extension Condition {
    var iconName: String? {
        type.iconName
    }
    
    var color: Color {
        type.color
    }
    
    var description: String {
        type.description
    }
}

struct AnyEquatableCondition: Condition {
    var condition: Condition
    
    var id: UUID {
        condition.id
    }
    
    var description: String {
        condition.description
    }
    
    var type: ConditionType {
        condition.type
    }
    
    var entities: [TextEntity] {
        condition.entities
    }
    
    func isEqualTo(_ other: Condition) -> Bool {
        condition.isEqualTo(other)
    }
}

extension AnyEquatableCondition: Equatable {
    static func ==(lhs: AnyEquatableCondition, rhs: AnyEquatableCondition) -> Bool {
        return lhs.condition.isEqualTo(rhs.condition)
    }
}


enum ConditionType: String, CaseIterable {
    case percentChange
    case priceChange
    case walletBalance
    case transactionFee
    case marketCap
    
    var description: String {
        switch self {
            case .percentChange:
                return "% Change"
            case .priceChange:
                return "Price"
            case .transactionFee:
                return "Transaction fee"
            case .marketCap:
                return "Market Cap"
            case .walletBalance:
                return "Wallet Balance"
        }
    }
    
    var iconName: String? {
        switch self {
            case .percentChange:
                return "percent"
            case .priceChange:
                return "chart.bar.fill"
            case .transactionFee:
                return "wind"
            case .marketCap:
                return "magnifyingglass"
            case .walletBalance:
                return "wallet.pass"
        }
    }
    
    var color: Color {
        switch self {
            case .priceChange:
                return .green
            case .transactionFee:
                return .orange
            case .marketCap:
                return .blue
            case .walletBalance:
                return .teal
            case .percentChange:
                return .purple
        }
    }
    
    func makeEntity() -> Condition {
        switch self {
            case .percentChange:
                return PercentChange(crypto: nil, comparator: nil, percentage: nil)
            case .priceChange:
                return PriceChange(crypto: nil, comparator: nil, price: nil)
            case .walletBalance:
                return WalletBalance(wallet: nil, crypto: nil, comparator: nil, price: nil)
            case .transactionFee:
                return TransactionFee(wallet: nil, crypto: nil, comparator: nil, price: nil)
            case .marketCap:
                return MarketCapChange(crypto: nil, comparator: nil, price: nil)
        }
    }
}
