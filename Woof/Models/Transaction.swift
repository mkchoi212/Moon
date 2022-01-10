//
//  Transaction.swift
//  Woof
//
//  Created by Mike Choi on 1/9/22.
//

import Foundation
import SwiftUI

final class Transaction: ObservableObject, Codable {
    init(id: String, token: Token?, value: Double?, price: Double?, type: String, mined_at: Int, hash: String, status: String, block_number: Int, address_from: String?, address_to: String?, fee: Fee?) {
        self.id = id
        self.token = token
        self.value = value
        self.price = price
        self.type = type
        self.mined_at = mined_at
        self.hash = hash
        self.status = status
        self.block_number = block_number
        self.address_from = address_from
        self.address_to = address_to
        self.fee = fee
    }
    
    var id: String
    var token: Token?
    var value: Double?
    var price: Double?
    var type: String
    var mined_at: Int
    var hash: String
    var status: String
    var block_number: Int
    var address_from: String?
    var address_to: String?
    var fee: Fee?
    
    func transactionQuantity() -> Double {
        return (value ?? 0) / oneETHinWEI
    }

    func transactionValue() -> NSNumber {
        if price != nil && value != nil {
            return NSNumber(value: (price ?? 0) * self.transactionQuantity())
        } else {
            return 0
        }
    }
    
    func title() -> String {
        return "\(type.capitalized) \(token?.symbol.uppercased() ?? "")"
    }
}
