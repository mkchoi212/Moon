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
