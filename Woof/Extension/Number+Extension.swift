//
//  Double+Extension.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import Foundation

extension NumberFormatter {
    static let percentage: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    static let pureDouble: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumFractionDigits = 2
        return nf
    }()
}

extension Double {
    var percentage: String {
        NumberFormatter.percentage.string(from: NSNumber(value: self)) ?? ""
    }
    
    var price: String {
        String(format: "%.2f", self)
    }
}
