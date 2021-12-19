//
//  WalletBalance.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI
import CoreData

final class WalletBalance: CardRepresentable, Condition {
    let type = ConditionType.walletBalance
    
    let id: UUID
    let wallet: WalletEntityProperty
    let cryptoSymbol: CryptoTypeProperty
    var comparator: ComparatorProperty
    var price: CryptoAmountProperty
   
    var properties: [CardProperty] {
        [
            StaticText(text: "Balance of"),
            cryptoSymbol,
            StaticText(text: "in"),
            wallet,
            StaticText(text: "is"),
            comparator,
            price
        ]
    }
    
    init(id: UUID, wallet: Wallet?, cryptoSymbol: String?, comparator: Comparator?, price: Double?) {
        self.id = id
        self.wallet = WalletEntityProperty(wallet: wallet)
        self.cryptoSymbol = CryptoTypeProperty(symbol: cryptoSymbol)
        self.comparator = ComparatorProperty(value: comparator)
        self.price = CryptoAmountProperty(cryptoSymbol: cryptoSymbol, amount: price)
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        let entity = WalletBalanceEntity(context: context)
        entity.id = id
        entity.type = type.rawValue
        entity.wallet = wallet.wallet?.address
        entity.cryptoSymbol = cryptoSymbol.symbol
        entity.comparator = comparator.value?.rawValue
        entity.price = price.amount ?? .nan
        return entity
    }
}

extension WalletBalance: ComparatorSettable {
    func set(comparator: Comparator, for propertyId: UUID) {
        self.comparator.value = comparator
    }
}

extension WalletBalance: Equatable {
    static func ==(lft: WalletBalance, rht: WalletBalance) -> Bool {
        lft.wallet.wallet == rht.wallet.wallet &&
        lft.cryptoSymbol.symbol == rht.cryptoSymbol.symbol &&
        lft.comparator.value == rht.comparator.value &&
        lft.price.amount == rht.price.amount
    }
}
