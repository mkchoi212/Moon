//
//  Theme.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable {
    case black, blue
}

struct ThemeManager {
    static let shared = ThemeManager()
    
    var theme: Theme
    
    init() {
        if let savedThemeRawValue = UserDefaultsConfig.theme,
           let savedTheme = Theme(rawValue: savedThemeRawValue) {
            theme = savedTheme
        } else {
            theme = .black
        }
    }
    
    var primary: Color {
        switch theme {
            case .black:
                return Color(uiColor: .systemBackground)
            case .blue:
                return .blue
        }
    }
}

extension Color {
    static var themePrimary: Color {
        ThemeManager.shared.primary
    }
}
