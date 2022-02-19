//
//  WoofApp.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI
import PartialSheet

@main
struct WoofApp: App {
    @StateObject var authModel = SettingsViewModel()
    @AppStorage("biometrics.enabled") var biometricsEnabled = false
    
    let sheetManager = PartialSheetManager()
    
    var body: some Scene {
        WindowGroup {
            if authModel.isAuthenticated || !authModel.isBiometricsEnabled {
                WoofTabView()
                    .animation(.easeIn(duration: 0.15), value: authModel.isAuthenticated)
                    .environmentObject(sheetManager)
            } else {
                Cover()
                    .environmentObject(authModel)
                    .onAppear {
                        authModel.authenticate()
                    }
            }
        }
    }
}
