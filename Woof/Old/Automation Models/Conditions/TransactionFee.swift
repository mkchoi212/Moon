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
    let cryptoSymbol: String?
    let comparator: Comparator?
    let price: Double?
  
    var properties: [CardProperty] {
        [
            StaticText(text: "Average transaction fee for"),
//            TextEntity(text: cryptoSymbol, action: .cryptoType(cryptoSymbol)),
            StaticText(text: "is"),
//            TextEntity(thresholdPrice: price, cryptoSymbol: cryptoSymbol)
        ]
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        ConditionEntity()
    }
}

extension TransactionFee: Equatable {
    static func ==(lft: TransactionFee, rht: TransactionFee) -> Bool {
        lft.wallet == rht.wallet &&
        lft.cryptoSymbol == rht.cryptoSymbol &&
        lft.comparator == rht.comparator &&
        lft.price == rht.price
    }
}
