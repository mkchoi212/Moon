//
//  NavigationBarAppearance.swift
//  Woof
//
//  Created by Mike Choi on 1/15/22.
//

import UIKit

struct NavigationBarAppearance {
    static let shared = NavigationBarAppearance()
    
    enum Mode {
        case solid, systemDefault
    }
    
    func set(mode: Mode) {
        switch mode {
            case .solid:
                let appr = UINavigationBarAppearance()
                appr.backgroundColor = .systemBackground
                appr.shadowColor = nil
                
                UINavigationBar.appearance().standardAppearance = appr
                UINavigationBar.appearance().scrollEdgeAppearance = appr
                UINavigationBar.appearance().compactAppearance = appr
                UINavigationBar.appearance().compactScrollEdgeAppearance = appr
            case .systemDefault:
                let appr = UINavigationBarAppearance()
                UINavigationBar.appearance().standardAppearance = appr
                UINavigationBar.appearance().scrollEdgeAppearance = appr
                UINavigationBar.appearance().compactAppearance = appr
                UINavigationBar.appearance().compactScrollEdgeAppearance = appr
        }
    }
}
