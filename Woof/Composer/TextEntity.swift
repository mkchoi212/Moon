//
//  TextEntity.swift
//  Woof
//
//  Created by Mike Choi on 12/13/21.
//

import SwiftUI

enum EditAction {
    case cryptoType, cryptoAmount, wallet
    case comparator(Comparator?)
    case percentage
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
}

struct TextEntity: Identifiable {
    var text: String?
    var action: EditAction?
    
    let id = UUID()
}

extension TextEntity {
    init(text: String) {
        self.init(text: text, action: nil)
    }
    
    init(thresholdPrice: Double?, crypto: Crypto?) {
        if let price = thresholdPrice, let crypto = crypto {
            self.init(text: "\(price.price)\(crypto.description)", action: .cryptoAmount)
        } else {
            self.init(text: nil, action: .cryptoAmount)
        }
    }
}
