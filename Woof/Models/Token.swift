//
//  Token.swift
//  Woof
//
//  Created by Mike Choi on 1/9/22.
//

import Foundation
import SwiftUI

class Token: ObservableObject, Codable {
    var id: String
    var name: String
    var symbol: String
    var quantity: String?
    var price: Price?
    var iconURL: String?
   
    init(id: String, name: String, symbol: String, quantity: String?, price: Price?, iconURL: String?) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.quantity = quantity
        self.price = price
        self.iconURL = iconURL
    }
    
    func value() -> NSNumber {
        if self.price != nil && self.quantity != nil {
            return NSNumber(value: (self.price?.value ?? 0) * self.tokenQuantity())
        } else {
            return 0
        }
    }
    
    func tokenQuantity() -> Double {
        return Double((self.quantity! as NSString).doubleValue) / oneETHinWEI
    }
    
    func percentChange() -> String {
        if self.price?.relativeChange24h != nil {
            return String(format: "%.2f", self.price?.relativeChange24h ?? 0) + "%"
        } else {
            return "0%"
        }
    }
}
