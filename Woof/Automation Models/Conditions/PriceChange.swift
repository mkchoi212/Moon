//
//  PriceChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct PriceChange: CardRepresentable, Condition {
    let type: TypeRepresentable = ConditionType.priceChange
    
    let id: UUID = .init()
    let crypto: Crypto
    let comparator: Comparator
    let price: Double
    
    var description: Text {
        return Text("\(crypto.description) \(comparator.comparatorDescription) \(price.price)\(crypto.description)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold, design: .rounded))
    }
}
