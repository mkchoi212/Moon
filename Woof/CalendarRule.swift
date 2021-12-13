//
//  CalendarRule.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI

enum CalendarRule: TypeRepresentable, Hashable {
    
    static let allCases: [CalendarRule] = [.everyHour(0), .everyDay(0), .everyMonth(0)]
    // Every day at 12am
    case everyHour(Int)
    
    // Every Monday, Tuesday, Wednesday
    case everyDay(Int)
    
    // Every April
    case everyMonth(Int)
    
    var color: Color {
        .brown
    }
    
    var description: String {
        switch self {
            case .everyHour(_):
                return "On hour"
            case .everyDay(_):
                return "On day"
            case .everyMonth(_):
                return "On month"
        }
    }
    
    var abbreviation: String {
        switch self {
            case .everyHour(_):
                return "H"
            case .everyDay(_):
                return "D"
            case .everyMonth(_):
                return "M"
        }
    }
    
    var iconName: String? {
        nil
    }
}
