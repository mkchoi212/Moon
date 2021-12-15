//
//  TransactionFee.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI
import CoreData

struct TransactionFee: CardRepresentable, Condition {
    let type = ConditionType.transactionFee
    
    let id: UUID = .init()
    let wallet: Wallet?
    let crypto: Crypto?
    let comparator: Comparator?
    let price: Double?
   
    var entities: [TextEntity] {
        [
            TextEntity(text: "Average transaction fee for"),
            TextEntity(text: crypto?.description, action: .cryptoType),
            TextEntity(text: "is"),
            TextEntity(thresholdPrice: price, crypto: crypto)
        ]
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        ConditionEntity()
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
