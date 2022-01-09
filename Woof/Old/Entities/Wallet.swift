//
//  Wallet.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import Foundation

struct Wallet: Equatable, Hashable {
    let address: String
    
    static let mike = Wallet(address: "0xf103eab10")
}

extension Wallet {
    init?(address: String?) {
        if let address = address {
            self.init(address: address)
        } else {
            return nil
        }
    }
}
