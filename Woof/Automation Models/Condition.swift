//
//  Condition.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

protocol ConditionDisplayable {
    var id: String { get }
}

enum Condition: ConditionDisplayable, Equatable, Hashable {
    
    static let allCases: [Condition] = [
        .percentageChange(.btc, .less, 0),
        .price(.btc, .less, 0),
        .gasEth(.equal, 0),
        .marketCap(.btc, .equal, 0),
        .wallet(.init(name: "foo", address: "bar"), .btc, .equal, 0)
    ]
    
    case percentageChange(Crypto, Comparator, Double)
    
    case price(Crypto, Comparator, Double)
    
    case gasEth(Comparator, Double)
    
    case marketCap(Crypto, Comparator, Double)
    
    case wallet(Wallet, Crypto, Comparator, Double)
    
    var description: String {
        switch self {
            case .percentageChange(_, _, _):
                return "% Change"
            case .price(_, _, _):
                return "Price"
            case .gasEth(_, _):
                return "ETH Gas"
            case .marketCap(_, _, _):
                return "Market Cap"
            case .wallet(_, _, _, _):
                return "Wallet Balance"
        }
    }
    
    var icon: Image {
        switch self {
            case .percentageChange(_, _, _):
                return Image(systemName: "percent")
            case .price(_, _, _):
                return Image(systemName: "chart.bar.fill")
            case .gasEth(_, _):
                return Image(systemName: "wind")
            case .marketCap(_, _, _):
                return Image(systemName: "magnifyingglass")
            case .wallet(_, _, _, _):
                return Image(systemName: "wallet.pass")
        }
    }
    
    var color: Color {
        switch self {
            case .percentageChange(_, _, _):
                return .purple
            case .price(_, _, _):
                return .green
            case .gasEth(_, _):
                return .orange
            case .marketCap(_, _, _):
                return .blue
            case .wallet(_, _, _, _):
                return .teal
        }
    }
    
    var humanizedDescription: Text {
        switch self {
            case .percentageChange(let crypto, let comparator, let double):
                return Text("\(crypto.description) \(comparator.actionDescription) \(double.percentage)")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                + Text(" in a ")
                    .font(.system(size: 18))
                + Text("day")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold))
            case .price(let crypto, let comparator, let double):
                return Text("\(crypto.description) \(comparator.comparatorDescription) \(double.price)\(crypto.description)")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            case .gasEth(let comparator, let double):
                return Text("Average ETH gas price is").font(.system(size: 18)) +
                Text(" \(comparator.comparatorDescription) \(double.price)ETH")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            case .marketCap(let crypto, let comparator, let price):
                return Text("\(crypto.description) market cap is \(comparator.comparatorDescription) \(price.price)\(crypto.description)")
            case .wallet(let wallet, let crypto, let comparator, let price):
                return Text(wallet.name + " \(crypto.description)")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                + Text(" balance is ") +
                Text("\(comparator.comparatorDescription) \(price.price)\(crypto.description)")
                    .foregroundColor(.blue)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
        }
    }
    
    var id: String {
        String(hashValue)
    }
}