//
//  Double+Extension.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import Foundation
import SwiftUI

extension NumberFormatter {
    static let percentage: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    static let pureDouble: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        return nf
    }()
    
    static let currency: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .currency
        nf.locale = .current
        nf.usesGroupingSeparator = true
        nf.minimumFractionDigits = 2
        nf.maximumFractionDigits = 6
        return nf
    }()
}

extension Double {
    var percentage: String {
        NumberFormatter.percentage.string(from: NSNumber(value: self)) ?? ""
    }
    
    /**
     For numbers already x 100
     */
    var signedPercentage: String {
        if self > 0 {
            return "+\((self / 100).percentage)"
        } else {
            return (self/100).percentage
        }
    }
    
    var price: String {
        String(format: "%.2f", self)
    }
    
    var currencyFormatted: String {
        NumberFormatter.currency.string(from: NSNumber(value: self)) ?? ""
    }
    
    var percentageColor: Color {
        if self > 0 {
            return .green
        } else if self < 0 {
            return .red
        } else {
            return .gray
        }
    }
}
