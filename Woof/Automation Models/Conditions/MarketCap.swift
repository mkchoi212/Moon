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
    var entity: ConditionEntity?
    
    var entities: [TextEntity] {
        [
            TextEntity(text: "Market cap of"),
            TextEntity(text: cryptoSymbol, action: .cryptoType(cryptoSymbol)),
            TextEntity(text: "is"),
            TextEntity(text: comparator?.comparatorDescription, action: .comparator(comparator)),
            TextEntity(thresholdPrice: price, cryptoSymbol: cryptoSymbol)
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
