//
//  Fee.swift
//  Woof
//
//  Created by Mike Choi on 1/9/22.
//

import Foundation

struct Fee: Codable {
    var value: Double
    var price: Double
    
    func feePrice() -> NSNumber {
        return NSNumber(value: price * feeValue())
    }
    
    func feeValue() -> Double {
        return value / oneETHinWEI
    }
}
