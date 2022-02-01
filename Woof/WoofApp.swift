//
//  WoofApp.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

@main
struct WoofApp: App {
    @StateObject var authModel = SettingsViewModel()
    @AppStorage("biometrics.enabled") var biometricsEnabled = false
    
    var body: some Scene {
        WindowGroup {
            if authModel.isAuthenticated || !authModel.isBiometricsEnabled {
                WoofTabView()
                    .animation(.easeIn(duration: 0.15), value: authModel.isAuthenticated)
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
