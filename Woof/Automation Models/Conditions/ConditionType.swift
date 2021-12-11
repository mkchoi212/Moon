//
//  Condition.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol Condition: CardRepresentable {
    var type: TypeRepresentable { get }
    func isEqualTo(_ other: Condition) -> Bool
}

extension Condition where Self: Equatable {
    func isEqualTo(_ other: Condition) -> Bool {
        guard let other = other as? Self else { return false }
        return self == other
    }
}

struct AnyEquatableCondition: Condition {
    var condition: Condition
    
    var id: UUID {
        condition.id
    }
    
    var description: Text {
        condition.description
    }
    
    var type: TypeRepresentable {
        condition.type
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


enum ConditionType: String, CaseIterable, TypeRepresentable {
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
}
