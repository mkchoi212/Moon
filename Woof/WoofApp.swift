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
            Group {
                if authModel.isAuthenticated || !authModel.isBiometricsEnabled {
                    WoofTabView()
                        .environmentObject(sheetManager)
                } else {
                    Cover()
                        .environmentObject(authModel)
                        .onAppear {
                            authModel.authenticate()
                        }
                }
            }
            .animation(.easeIn(duration: 0.25), value: authModel.isAuthenticated)
        }
    }
}
