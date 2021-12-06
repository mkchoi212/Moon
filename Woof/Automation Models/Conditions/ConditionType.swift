//
//  Condition.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol Condition {
    var type: TypeRepresentable { get }
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
    
    var icon: Image? {
        switch self {
            case .percentChange:
                return Image(systemName: "percent")
            case .priceChange:
                return Image(systemName: "chart.bar.fill")
            case .transactionFee:
                return Image(systemName: "wind")
            case .marketCap:
                return Image(systemName: "magnifyingglass")
            case .walletBalance:
                return Image(systemName: "wallet.pass")
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
