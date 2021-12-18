//
//  PercentageChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI
import CoreData

struct PercentChange: CardRepresentable, Condition {
    
    let type = ConditionType.percentChange
    
    let id: UUID = .init()
    let cryptoSymbol: String?
    let comparator: Comparator?
    let percentage: Double?
    
    var properties: [CardProperty] {
        [
            CryptoTypeProperty(cryptoSymbol: cryptoSymbol),
            ComparatorProperty(comparator: comparator),
            PercentageProperty(percentage: percentage)
        ]
    }
    
//    static func make(with entities: [TextEntity]) -> CardRepresentable {
//        PercentChange(cryptoSymbol: <#T##String?#>,
//                      comparator: <#T##Comparator?#>,
//                      percentage: <#T##Double?#>,
//                      entity: <#T##ConditionEntity?#>)
//    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        ConditionEntity()
    }
}

extension PercentChange: Equatable {
    static func ==(lft: PercentChange, rht: PercentChange) -> Bool {
        lft.cryptoSymbol == rht.cryptoSymbol &&
        lft.comparator == rht.comparator &&
        lft.percentage == rht.percentage
    }
}
