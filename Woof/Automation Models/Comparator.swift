//
//  Comparator.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import Foundation

enum Comparator: String, CaseIterable {
    case greater, less, equal
    
    var description: String {
        switch self {
            case .equal:
                return "equal to"
            default:
                return comparatorDescription
        }
    }
    
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
    
    var imageName: String {
        switch self {
            case .greater:
                return "greaterthan"
            case .less:
                return "lessthan"
            case .equal:
                return "equal"
        }
    }
}
