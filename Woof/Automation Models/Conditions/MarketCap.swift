//
//  MarketCapChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct MarketCapChange: CardRepresentable, Condition {
    let type: TypeRepresentable = ConditionType.marketCap
    
    let id: UUID = .init()
    let crypto: Crypto
    let comparator: Comparator
    let price: Double
    
    var description: Text {
        return Text("\(crypto.description) market cap is \(comparator.comparatorDescription) \(price.price)\(crypto.description)")
    }
}

extension MarketCapChange: Equatable {
    static func ==(lft: MarketCapChange, rht: MarketCapChange) -> Bool {
        lft.crypto == rht.crypto &&
        lft.comparator == rht.comparator &&
        lft.price == rht.price
    }
}