//
//  TextEntity.swift
//  Woof
//
//  Created by Mike Choi on 12/13/21.
//

import SwiftUI

enum EditAction {
    case cryptoType(String?), cryptoAmount, wallet
    case comparator(Comparator?)
    case percentage(Double)
    case email
    
    var placeholder: String {
        switch self {
            case .cryptoType:
                return "Select crypto"
            case .cryptoAmount:
                return "Crypto amount"
            case .wallet:
                return "Select wallet"
            case .comparator:
                return "Comparator"
            case .percentage:
                return "Percentage"
            case .email:
                return "Email"
        }
    }
    
    var cryptoType: String? {
        if case .cryptoType(let type) = self {
            return type
        } else {
            return nil
        }
    }
}

final class TextEntity: Identifiable {
    var text: String?
    var action: EditAction?
    
    let id = UUID()
    
    init(text: String?, action: EditAction?) {
        self.text = text
        self.action = action
    }
}

extension TextEntity {
    convenience init(text: String) {
        self.init(text: text, action: nil)
    }
    
    convenience init(thresholdPrice: Double?, cryptoSymbol: String?) {
        if let price = thresholdPrice, let crypto = cryptoSymbol {
            self.init(text: "\(price.price)\(crypto)", action: .cryptoAmount)
        } else {
            self.init(text: nil, action: .cryptoAmount)
        }
    }
}
