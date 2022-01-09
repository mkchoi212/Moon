//
//  Transfer.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct Transfer: CardRepresentable, Action {
    let type = ActionType.transfer
    
    let id: UUID = .init()
    let cryptoSymbol: String?
    let fromWallet: Wallet?
    let toWallet: Wallet?
    let amount: Double?
    
    var properties: [CardProperty] {
        [
            StaticText(text: "Transfer"),
            StaticText(text: "from"),
            StaticText(text: "to")
        ]
    }
}

extension Transfer: Equatable {
    static func ==(lft: Transfer, rht: Transfer) -> Bool {
        lft.cryptoSymbol == rht.cryptoSymbol &&
        lft.fromWallet == rht.fromWallet &&
        lft.toWallet == rht.toWallet &&
        lft.amount == rht.amount
    }
}
