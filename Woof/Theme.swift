//
//  Theme.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import Foundation
import SwiftUI

enum Theme: String, CaseIterable {
    case mono, blue
}

struct ThemeManager {
    static let shared = ThemeManager()
    
    var theme: Theme
    
    init() {
        if let savedThemeRawValue = UserDefaultsConfig.theme,
           let savedTheme = Theme(rawValue: savedThemeRawValue) {
            theme = savedTheme
        } else {
            theme = .mono
        }
    }
    
    var primary: Color {
        switch theme {
            case .mono:
                return Color(uiColor: .systemBackground)
            case .blue:
                return .blue
        }
    }
    
    var text: Color {
        switch theme {
            case .mono:
                return Color(uiColor: .label)
            case .blue:
                return .blue
        }
    }
}

extension Color {
    static var themePrimary: Color {
        ThemeManager.shared.primary
    }
    
    static var themeControl: Color {
        ThemeManager.shared.text
    }
    
    static var themeText: Color {
        ThemeManager.shared.text
    }
}
