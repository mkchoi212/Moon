//
//  Transaction.swift
//  Woof
//
//  Created by Mike Choi on 1/9/22.
//

import Foundation
import SwiftUI

final class Transaction: ObservableObject, Codable {
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
    
    // Transactionchange with "out" direction
    var outChange: TransactionChange? {
        changes?.first { $0.direction == "out" }
    }
    func transactionQuantity() -> Double {
        return Double(outChange?.value ?? 0) / oneETHinWEI
    }

    func transactionValue() -> NSNumber {
        guard let outChange = outChange else {
            return 0
        }

        if outChange.price != nil {
            return NSNumber(value: (outChange.price ?? 0) * self.transactionQuantity())
        } else {
            return 0
        }
    }
    
    func title() -> String {
        return "\(type.capitalized) \(outChange?.token.symbol.uppercased() ?? "")"
    }
}
