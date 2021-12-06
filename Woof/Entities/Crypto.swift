//
//  Crypto.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import Foundation

enum Crypto: String {
    case btc, eth
    
    var description: String {
        rawValue.uppercased()
    }
}
