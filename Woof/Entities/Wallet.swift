//
//  Wallet.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import Foundation

struct Wallet: Hashable {
    let name: String
    let address: String
    
    static let mike = Wallet(name: "Mike's Metamask", address: "0xf103eab10")
}
