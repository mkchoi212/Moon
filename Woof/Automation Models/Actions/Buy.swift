//
//  Buy.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct Buy: Action, CardRepresentable {
    let type = ActionType.buy
    
    let id: UUID = .init()
    let crypto: Crypto
    let amount: Double
    let wallet: Wallet
   
    var entities: [TextEntity] {
        []
    }
    
    var description: Text {
        return Text("Buy ")
            .font(.system(size: 18))
        + Text("\(amount.price) \(crypto.description)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
    }
}

extension Buy: Equatable {
    static func ==(lft: Buy, rht: Buy) -> Bool {
        lft.crypto == rht.crypto &&
        lft.wallet == rht.wallet &&
        lft.amount == rht.amount
    }
}
