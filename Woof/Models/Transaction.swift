//
//  Transaction.swift
//  Woof
//
//  Created by Mike Choi on 1/9/22.
//

import Foundation
import SwiftUI

final class Transaction: ObservableObject, Identifiable, Codable {
    var id: String
    var type: String
    var `protocol`: String?
    var minedAt: Int
    var blockNumber: Int
    var status: String
    var hash: String
    var direction: String?
    var addressFrom: String?
    var addressTo: String?
    var contract: String?
    var nonce: Int?
    var changes: [TransactionChange]?
    var fee: Fee?
    
    // TODO: (Ask) it's a dict??
    //    var meta: String?
    
    init(
        id: String,
        type: String,
        `protocol`: String?,
        minedAt: Int,
        blockNumber: Int,
        status: String,
        hash: String,
        direction: String?,
        addressFrom: String?,
        addressTo: String?,
        contract: String?,
        nonce: Int?,
        changes: [TransactionChange]?,
        fee: Fee?
    ) {
        self.id = id
        self.type = type
        self.`protocol` = `protocol`
        self.minedAt = minedAt
        self.blockNumber = blockNumber
        self.status = status
        self.hash = hash
        self.direction = direction
        self.addressFrom = addressFrom
        self.addressTo = addressTo
        self.contract = contract
        self.nonce = nonce
        self.changes = changes
        self.fee = fee
    }
   
    static let token = Token(id: "abc", name: "Ethereum", type: "crypto", symbol: "ETH", quantity: "1.4232", price: Price(value: 2301.42, relativeChange24h: 0.1212), iconUrl: "https://token-icons.s3.amazonaws.com/eth.png")
    
    static let dummy = Transaction(id: UUID().uuidString, type: "Buy", protocol: "ETH", minedAt: 1231231231, blockNumber: 123123, status: "Confirmed", hash: "lkjaiosjdf123a", direction: "to", addressFrom: "0x123123", addressTo: "0x123123", contract: nil, nonce: 12319,
                                   changes: [.init(asset: token, value: 1231231231231212, direction: "to", addressFrom: "from", addressTo: "asdf", price: 12312312312312312)], fee: nil)
    
    var change: TransactionChange? {
        changes?.first
    }
    
    func transactionQuantity() -> Double {
        return Double(change?.value ?? 0) / oneETHinWEI
    }
    
    func transactionValue() -> Double {
        guard let change = change else {
            return 0
        }
        
        if change.price != nil {
            return (change.price ?? 0) * self.transactionQuantity()
        } else {
            return 0
        }
    }
    
    func title() -> String {
        return "\(type.capitalized) \(change?.asset.symbol.uppercased() ?? "")"
    }
}
