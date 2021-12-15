//
//  Crypto.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import Foundation

enum Crypto: String {
    case btc, eth, ohm
    
    var description: String {
        rawValue.uppercased()
    }
}

extension Crypto {
    init?(rawValue: String?) {
        if let rawValue = rawValue {
            self.init(rawValue: rawValue)
        } else {
            return nil
        }
    }
}
