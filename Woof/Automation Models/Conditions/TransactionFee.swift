//
//  TransactionFee.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct TransactionFee: CardRepresentable, Condition {
    let type: TypeRepresentable = ConditionType.transactionFee
    
    let id: UUID = .init()
    let wallet: Wallet
    let crypto: Crypto
    let comparator: Comparator
    let price: Double
    
    var description: Text {
        return Text("Average \(crypto.description) transaction fee is").font(.system(size: 18)) +
        Text(" \(comparator.comparatorDescription) \(price.price)\(crypto.description)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
    }
}
