//
//  TransactionFee.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct TransactionFee: CardRepresentable, Condition {
    let type = ConditionType.transactionFee
    
    let id: UUID = .init()
    let wallet: Wallet
    let crypto: Crypto
    let comparator: Comparator
    let price: Double
   
    var entities: [TextEntity] {
        []
    }
    
    var description: Text {
        return Text("Average \(crypto.description) transaction fee is").font(.system(size: 18)) +
        Text(" \(comparator.comparatorDescription) \(price.price)\(crypto.description)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
    }
}

extension TransactionFee: Equatable {
    static func ==(lft: TransactionFee, rht: TransactionFee) -> Bool {
        lft.wallet == rht.wallet &&
        lft.crypto == rht.crypto &&
        lft.comparator == rht.comparator &&
        lft.price == rht.price
    }
}
