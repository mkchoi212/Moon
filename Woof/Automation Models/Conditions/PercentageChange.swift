//
//  PercentageChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct PercentChange: CardRepresentable, Condition {
    let type = ConditionType.percentChange
    
    let id: UUID = .init()
    let crypto: Crypto?
    let comparator: Comparator?
    let percentage: Double?
    
    var entities: [TextEntity] {
        [
            TextEntity(text: crypto?.description, action: .cryptoType),
            TextEntity(text: comparator?.actionDescription, action: .comparator(comparator)),
            TextEntity(text: percentage?.percentage, action: .percentage),
        ]
    }
}

extension PercentChange: Equatable {
    static func ==(lft: PercentChange, rht: PercentChange) -> Bool {
        lft.crypto == rht.crypto &&
        lft.comparator == rht.comparator &&
        lft.percentage == rht.percentage
    }
}
