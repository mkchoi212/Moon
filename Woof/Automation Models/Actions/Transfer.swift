//
//  Transfer.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct Transfer: CardRepresentable, Condition {
    let type: TypeRepresentable = ActionType.transfer
    
    let id: UUID = .init()
    let crypto: Crypto
    let fromWallet: Wallet
    let toWallet: Wallet
    let amount: Double
    
    var description: Text {
        return Text("Transfer ")
            .font(.system(size: 18))
        + Text("\(amount.price) \(crypto.description)")
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
        + Text(" from ")
            .font(.system(size: 18))
        +  Text(fromWallet.name)
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
        + Text(" to ")
            .font(.system(size: 18))
        +  Text(toWallet.name)
            .foregroundColor(.blue)
            .font(.system(size: 18, weight: .semibold))
    }
}
