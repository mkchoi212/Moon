//
//  TransactionChange.swift
//  Woof
//
//  Created by Mike Choi on 1/11/22.
//

import Foundation

struct TransactionChange: Codable {
    let token: Token
    let value: Int
    let direction: String
    let addressFrom: String
    let addressTo: String
    let price: Double?
}
