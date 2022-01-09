//
//  WoofTabView.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

struct WoofTabView: View {
    @StateObject var walletViewModel = WalletConnectionViewModel()
    @State var presentWalletSelector = false
    
    let wallet = WalletModel()
    
    var body: some View {
        TabView {
            CoinView(presentWalletSelector: $presentWalletSelector)
                .environmentObject(wallet)
                .environmentObject(walletViewModel)
                .tabItem {
                    Label("Coins", systemImage: "moon.fill")
                }
            
            Text("Objects")
                .tabItem {
                    Label("Objects", systemImage: "square")
                }
        }
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
