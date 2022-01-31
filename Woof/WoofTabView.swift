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
    @State var presentNFTModal = false
    @State var nftSelection: NFTSelection? = nil
    
    var body: some View {
        TabView {
            CoinView(presentWalletSelector: $presentWalletSelector)
                .environmentObject(wallet)
                .tabItem {
                    Label("Coins", systemImage: "moon.fill")
                }
           
            CollectiblesView(nftSelection: $nftSelection)
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
        //https://github.com/AndreaMiotto/PartialSheet
        .bottomSheet(isPresented: $presentWalletSelector,
                     height: CGFloat((walletViewModel.walletAddresses.count * 100) + 150),
                     topBarHeight: 14,
                     topBarBackgroundColor: .modalBackground,
                     content: {
            WalletSelectorView()
                .environmentObject(walletViewModel)
        })
        .sheet(item: $nftSelection, content: { nftSelection in
            CollectiblesDetailView(nft: nftSelection.nft, collection: nftSelection.collection)
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WoofTabView()
    }
}
