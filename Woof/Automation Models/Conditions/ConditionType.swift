//
//  Condition.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI
import CoreData

protocol Condition: CardRepresentable {
    var type: ConditionType { get }
    func isEqualTo(_ other: Condition) -> Bool
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity
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
   
    var properties: [CardProperty] {
        condition.properties
    }
    
    func isEqualTo(_ other: Condition) -> Bool {
        condition.isEqualTo(other)
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        condition.coreDataModel(with: context)
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
                return PercentChange(id: UUID(), symbol: nil, percentage: nil)
            case .priceChange:
                return PriceChange(id: UUID(), cryptoSymbol: nil, comparator: nil, price: nil)
            case .walletBalance:
                return WalletBalance(id: UUID(), wallet: nil, cryptoSymbol: nil, comparator: nil, price: nil)
            case .transactionFee:
                return TransactionFee(wallet: nil, cryptoSymbol: nil, comparator: nil, price: nil)
            case .marketCap:
                return MarketCapChange(cryptoSymbol: nil, comparator: nil, price: nil)
        }
    }
}
