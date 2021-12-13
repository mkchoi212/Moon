//
//  MarketCapChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct MarketCapChange: CardRepresentable, Condition {
    let type = ConditionType.marketCap
    
    let id: UUID = .init()
    let crypto: Crypto?
    let comparator: Comparator?
    let price: Double?
   
    var entities: [TextEntity] {
        [
            TextEntity(text: "Market cap of"),
            TextEntity(text: crypto?.description, action: .cryptoType),
            TextEntity(text: "is"),
            TextEntity(text: comparator?.comparatorDescription, action: .comparator),
            TextEntity(thresholdPrice: price, crypto: crypto)
        ]
    }
}

extension MarketCapChange: Equatable {
    static func ==(lft: MarketCapChange, rht: MarketCapChange) -> Bool {
        lft.crypto == rht.crypto &&
        lft.comparator == rht.comparator &&
        lft.price == rht.price
    }
}
