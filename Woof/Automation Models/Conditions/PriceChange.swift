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
    
    let id: UUID
    let crypto: Crypto?
    let comparator: Comparator?
    let price: Double?
    var entity: ConditionEntity?
    
    var entities: [TextEntity] {
        [
            TextEntity(text: crypto?.description, action: .cryptoType),
            TextEntity(text: comparator?.comparatorDescription, action: .comparator(comparator)),
            TextEntity(thresholdPrice: price, crypto: crypto)
        ]
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        let entity = PriceChangeEntity(context: context)
        entity.id = id
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

// MARK: - CoreData

extension PriceChange {
    init?(entity: PriceChangeEntity?) {
        guard let entity = entity, let id = entity.id else {
            return nil
        }

        self.init(id: id,
                  crypto: Crypto(rawValue: entity.crypto),
                  comparator: Comparator(rawValue: entity.comparator),
                  price: entity.price,
                  entity: entity)
    }
}
