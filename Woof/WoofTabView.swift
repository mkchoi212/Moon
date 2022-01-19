//
//  WoofTabView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

struct WoofTabView: View {
    @StateObject var walletViewModel = WalletConnectionViewModel()
    @StateObject var wallet = WalletModel()
    @StateObject var openSea = OpenSea()
    
    @State var presentWalletSelector = false
    
    var body: some View {
        TabView {
            CoinView(presentWalletSelector: $presentWalletSelector)
                .environmentObject(wallet)
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
        .bottomSheet(isPresented: $presentWalletSelector,
                     height: CGFloat((walletViewModel.walletAddresses.count * 100) + 150),
                     topBarHeight: 14,
                     topBarBackgroundColor: .modalBackground,
                     content: {
            WalletSelectorView()
                .environmentObject(walletViewModel)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WoofTabView()
    }
}
