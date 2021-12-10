//
//  Automation.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

struct Automation: Identifiable {
    let id = UUID()
    let title: String
    let color: Color
    let icon: Image
    let condition: [Condition]
    let actions: [Action]
    
    static let empty = Automation(title: "", color: .blue, icon: Image(systemName: "moon"), condition: [], actions: [])
    
    static let dummy: [Automation] = []
//    [
//        Automation(title: "Buy the dip", color: .red, icon: Image(systemName: "arrow.down"),
//                   condition: [
//                    PriceChange(crypto: .btc, comparator: .less, price: 69000)
//                   ],
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
//    ]
}
