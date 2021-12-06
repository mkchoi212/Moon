//
//  Comparator.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import Foundation

enum Comparator: String {
    case greater, less, equal
    
    var comparatorDescription: String {
        switch self {
            case .greater:
                return "greater than"
            case .less:
                return "less than"
            case .equal:
                return "is"
        }
    }
    var actionDescription: String {
        switch self {
            case .greater:
                return "increases"
            case .less:
                return "decreases"
            case .equal:
                return "is"
        }
    }
}
