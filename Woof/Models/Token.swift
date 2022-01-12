//
//  Token.swift
//  Woof
//
//  Created by Mike Choi on 1/9/22.
//

import Foundation
import SwiftUI

final class Token: ObservableObject, Codable {
    var id: String
    var name: String
    var symbol: String
    var quantity: String?
    var price: Price?
    var iconUrl: String?
  
    init(id: String, name: String, type: String, symbol: String, quantity: String?, price: Price?, iconUrl: String?) {
        self.id = id
        self.name = name
//        self.type = type
        self.symbol = symbol
        self.quantity = quantity
        self.price = price
        self.iconUrl = iconUrl
    }
}

// MARK: -

extension Token {
    func value() -> Double {
        if self.price != nil && self.quantity != nil {
            return (self.price?.value ?? 0) * self.tokenQuantity()
        } else {
            return 0
        }
    }
    
    func tokenQuantity() -> Double {
        if let quantity = quantity {
            return Double((quantity as NSString).doubleValue) / oneETHinWEI
        } else {
            return 0
        }
    }
    
    func percentChange() -> String {
        if self.price?.relativeChange24h != nil {
            return String(format: "%.2f", self.price?.relativeChange24h ?? 0) + "%"
        } else {
            return "0%"
        }
    }
}
