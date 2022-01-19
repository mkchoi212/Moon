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
        case solid(UIColor?), systemDefault
    }
    
    func set(mode: Mode) {
        switch mode {
            case .solid(let color):
                let appr = UINavigationBarAppearance()
                appr.backgroundColor = color ?? .systemBackground
                appr.shadowColor = nil
               
                UINavigationBar.appearance().backgroundColor = appr.backgroundColor
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
