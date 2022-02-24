//
//  WoofTabView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI
import PartialSheet

struct ToastPayload: Identifiable, Equatable {
    let id = UUID()
    let message: String
}

struct WoofTabView: View {
    @StateObject var wallet = WalletModel()
    @StateObject var openSea = OpenSea()
    @StateObject var connectionViewModel = WalletConnectionViewModel()
    
    @State var presentWalletSelector = false
    @State var presentNFTModal = false
    
    @EnvironmentObject var sheetManager: PartialSheetManager
    @AppStorage("did.complete.onboarding") var didCompleteOnboarding = false
    
    var body: some View {
        Group {
            if !didCompleteOnboarding {
                OnboardingView()
                    .environmentObject(connectionViewModel)
            } else {
                TabView {
                    CoinView()
                        .environmentObject(wallet)
                        .environmentObject(sheetManager)
                        .environmentObject(connectionViewModel)
                        .tabItem {
                            Label("Coins", systemImage: "moon.fill")
                        }
                    
                    CollectiblesView()
                        .environmentObject(openSea)
                        .tabItem {
                            Label("Collectibles", systemImage: "square")
                        }
                    
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "person")
                        }
                }
                .tint(.accentColor)
                .addPartialSheet()
            }
        }
        .animation(.easeIn(duration: 0.25), value: didCompleteOnboarding)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WoofTabView()
    }
}
