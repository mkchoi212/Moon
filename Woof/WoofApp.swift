//
//  WoofApp.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

@main
struct WoofApp: App {
    init() {
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .systemBackground
//        appearance.shadowColor = nil
//        
//        UINavigationBar.appearance().standardAppearance = appearance
//        UINavigationBar.appearance().compactAppearance = appearance
//        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

    var body: some Scene {
        WindowGroup {
            WoofTabView()
        }
    }
}
