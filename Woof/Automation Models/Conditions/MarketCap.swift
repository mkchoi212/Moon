//
//  MarketCapChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI
import CoreData

struct MarketCapChange: CardRepresentable, Condition {
    let type = ConditionType.marketCap
    
    let id: UUID = .init()
    let cryptoSymbol: String?
    let comparator: Comparator?
    let price: Double?
    
    var properties: [CardProperty] {
        [
            StaticText(text: "Market cap of"),
            CryptoTypeProperty(cryptoSymbol: cryptoSymbol),
            StaticText(text: "is"),
            ComparatorProperty(comparator: comparator),
            CryptoAmountProperty(cryptoSymbol: cryptoSymbol, amount: price)
        ]
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        ConditionEntity()
    }
}

extension MarketCapChange: Equatable {
    static func ==(lft: MarketCapChange, rht: MarketCapChange) -> Bool {
        lft.cryptoSymbol == rht.cryptoSymbol &&
        lft.comparator == rht.comparator &&
        lft.price == rht.price
    }
}
