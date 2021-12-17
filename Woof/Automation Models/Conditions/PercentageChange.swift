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
    var entity: ConditionEntity?
    
    var entities: [TextEntity] {
        [
            TextEntity(text: cryptoSymbol, action: .cryptoType(cryptoSymbol)),
            TextEntity(text: comparator?.actionDescription, action: .comparator(comparator)),
            TextEntity(text: percentage?.percentage, action: .percentage(percentage ?? 0)),
        ]
    }
    
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
