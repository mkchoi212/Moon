//
//  Automation.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct Automation: Identifiable {
    let id: UUID
    let title: String
    let color: Color
    let iconName: String
    let conditions: [AnyEquatableCondition]
    let actions: [AnyEquatableAction]
    
    static let empty = Automation(id: UUID(), title: "", color: .blue, iconName: "moon.fill", conditions: [], actions: [])
    
    static let dummy: [Automation] =
    [
        Automation(id: UUID(), title: "Buy the dip", color: .red, iconName: "arrow.down",
                   conditions: [
                    AnyEquatableCondition(condition: PriceChange(id: UUID(), crypto: .btc, comparator: .less, price: 69000))
                   ], actions: [])
//                   actions: [
//                    SendNotification(message: ""),
//                    Buy(crypto: .eth, amount: 100, wallet: .mike)
//                   ]),
//        Automation(title: "Stake Olympus", color: .purple, icon: Image(systemName: "lock.fill"),
//                   condition: [
//                    PriceChange(crypto: .eth, comparator: .less, price: 5000)
//                   ],
//                   actions: [
//                    SendNotification(message: ""),
//                    Swap(wallet: .mike, fromCrypto: .eth, toCrypto: .ohm, amount: 4)
//                   ])
    ]
}
