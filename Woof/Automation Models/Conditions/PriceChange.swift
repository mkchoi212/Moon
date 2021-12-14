//
//  PriceChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct PriceChange: CardRepresentable, Condition {
    let type = ConditionType.priceChange
    
    let id: UUID = .init()
    let crypto: Crypto?
    let comparator: Comparator?
    let price: Double?
    
    var entities: [TextEntity] {
        [
            TextEntity(text: crypto?.description, action: .cryptoType),
            TextEntity(text: comparator?.comparatorDescription, action: .comparator(comparator)),
            TextEntity(thresholdPrice: price, crypto: crypto)
        ]
    }
}

extension PriceChange: Equatable {
    static func ==(lft: PriceChange, rht: PriceChange) -> Bool {
        lft.crypto == rht.crypto &&
        lft.comparator == rht.comparator &&
        lft.price == rht.price
    }
}
