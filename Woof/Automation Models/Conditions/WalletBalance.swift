//
//  WalletBalance.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct WalletBalance: CardRepresentable, Condition {
    let type: TypeRepresentable = ConditionType.walletBalance
    
    let id: UUID = .init()
    let wallet: Wallet
    let crypto: Crypto
    let comparator: Comparator
    let price: Double
    
    var description: Text {
        return Text(wallet.name + " \(crypto.description)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
        + Text(" balance is ") +
        Text("\(comparator.comparatorDescription) \(price.price)\(crypto.description)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
    }
}
