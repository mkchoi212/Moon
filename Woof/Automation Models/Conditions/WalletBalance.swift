//
//  WalletBalance.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI
import CoreData

struct WalletBalance: CardRepresentable, Condition {
    let type = ConditionType.walletBalance
    
    let id: UUID = .init()
    let wallet: Wallet?
    let cryptoSymbol: String?
    let comparator: Comparator?
    let price: Double?
    
    var entities: [TextEntity] {
        [
            TextEntity(text: "Balance of"),
            TextEntity(text: wallet?.name, action: .wallet),
            TextEntity(text: "is"),
            TextEntity(text: comparator?.comparatorDescription, action: .comparator(comparator)),
            TextEntity(thresholdPrice: price, cryptoSymbol: cryptoSymbol)
        ]
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        ConditionEntity()
    }
}

extension WalletBalance: Equatable {
    static func ==(lft: WalletBalance, rht: WalletBalance) -> Bool {
        lft.wallet == rht.wallet &&
        lft.cryptoSymbol == rht.cryptoSymbol &&
        lft.comparator == rht.comparator &&
        lft.price == rht.price
    }
}
