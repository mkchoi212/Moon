//
//  PercentageChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct PercentChange: CardRepresentable, Condition {
    let type: TypeRepresentable = ConditionType.percentChange
    
    let id: UUID = .init()
    let crypto: Crypto
    let comparator: Comparator
    let percentage: Double
    
    var description: Text {
        return Text("\(crypto.description) \(comparator.actionDescription) \(percentage.percentage)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
        + Text(" in a ")
            .font(.system(size: 18))
        + Text("day")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
    }
}

extension PercentChange: Equatable {
    static func ==(lft: PercentChange, rht: PercentChange) -> Bool {
        lft.crypto == rht.crypto &&
        lft.comparator == rht.comparator &&
        lft.percentage == rht.percentage
    }
}
