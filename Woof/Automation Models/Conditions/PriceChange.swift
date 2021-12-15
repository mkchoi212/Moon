//
//  PriceChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI
import CoreData

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
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        let entity = PriceChangeEntity(context: context)
        entity.type = type.rawValue
        entity.crypto = crypto?.rawValue
        entity.comparator = comparator?.rawValue
        entity.price = price ?? .nan
        return entity
    }
}

extension PriceChange: Equatable {
    static func ==(lft: PriceChange, rht: PriceChange) -> Bool {
        lft.crypto == rht.crypto &&
        lft.comparator == rht.comparator &&
        lft.price == rht.price
    }
}
