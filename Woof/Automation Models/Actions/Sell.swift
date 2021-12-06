//
//  Sell.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct Sell: CardRepresentable, Condition {
    let type: TypeRepresentable = ActionType.sell
    
    let id: UUID = .init()
    let crypto: Crypto
    let amount: Double
    let wallet: Wallet
    
    var description: Text {
        return Text("Sell ")
            .font(.system(size: 18))
        + Text("\(amount.price) \(crypto.description)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
    }
}
