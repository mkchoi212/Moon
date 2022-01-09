//
//  Swap.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct Swap: CardRepresentable, Action {
    let type = ActionType.swap
    
    let id: UUID = .init()
    let wallet: Wallet
    let fromCrypto: Crypto
    let toCrypto: Crypto
    let amount: Double
   
    var properties: [CardProperty] {
        []
    }
    
    var description: Text {
        return Text("Swap ")
            .font(.system(size: 18))
        + Text("\(amount.price) \(fromCrypto.description)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
        + Text(" to ")
            .font(.system(size: 18))
        +  Text(toCrypto.description)
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
        + Text(" in ")
            .font(.system(size: 18))
        +  Text(wallet.address.prefix(10))
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
    }
}

extension Swap: Equatable {
    static func ==(lft: Swap, rht: Swap) -> Bool {
        lft.wallet == rht.wallet &&
        lft.fromCrypto == rht.fromCrypto &&
        lft.toCrypto == rht.toCrypto &&
        lft.amount == rht.amount
    }
}
