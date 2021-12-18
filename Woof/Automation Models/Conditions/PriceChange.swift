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
    let cryptoSymbol: String?
    let comparator: Comparator?
    let price: Double?
    
    var entities: [TextEntity] {
        [
            TextEntity(text: cryptoSymbol, action: .cryptoType(cryptoSymbol)),
            TextEntity(text: comparator?.comparatorDescription, action: .comparator(comparator)),
            TextEntity(thresholdPrice: price, cryptoSymbol: cryptoSymbol)
        ]
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        let entity = PriceChangeEntity(context: context)
        entity.id = id
        entity.type = type.rawValue
        entity.cryptoSymbol = cryptoSymbol
        entity.comparator = comparator?.rawValue
        entity.price = price ?? .nan
        return entity
    }
}

extension PriceChange: Equatable {
    static func ==(lft: PriceChange, rht: PriceChange) -> Bool {
        lft.cryptoSymbol == rht.cryptoSymbol &&
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
                  cryptoSymbol: entity.cryptoSymbol,
                  comparator: Comparator(rawValue: entity.comparator),
                  price: entity.price)
    }
}
