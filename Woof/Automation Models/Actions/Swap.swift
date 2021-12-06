//
//  Swap.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct Swap: CardRepresentable, Action {
    let type: TypeRepresentable = ActionType.swap
    
    let id: UUID = .init()
    let wallet: Wallet
    let fromCrypto: Crypto
    let toCrypto: Crypto
    let amount: Double
    
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
        +  Text(wallet.name)
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
    }
}
