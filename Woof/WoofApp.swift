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
    @StateObject var authModel = LocalAuthModel()
    @StateObject var connectionViewModel = WalletConnectionViewModel()
    @AppStorage("biometrics.enabled") var biometricsEnabled = false
    @AppStorage("did.complete.onboarding") var didCompleteOnboarding = false
    
    let sheetManager = PartialSheetManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !didCompleteOnboarding {
                    OnboardingView()
                        .environmentObject(connectionViewModel)
                        .environmentObject(authModel)
                } else if (authModel.isAuthenticated || !authModel.isBiometricsEnabled) {
                    WoofTabView()
                        .environmentObject(sheetManager)
                        .environmentObject(connectionViewModel)
                        .environmentObject(authModel)
                } else {
                    Cover()
                        .environmentObject(authModel)
                        .onAppear {
                            if didCompleteOnboarding {
                                authModel.authenticate()
                            }
                        }
                }
            }
            .animation(.easeIn(duration: 0.25), value: authModel.isAuthenticated)
        }
    }
}
