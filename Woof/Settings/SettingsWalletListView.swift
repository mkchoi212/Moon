//
//  SettingsWalletListView.swift
//  Woof
//
//  Created by Mike Choi on 12/22/21.
//

import Foundation
import SwiftUI

struct SettingsWalletListView: View {
    @State var _selectedWallet: Wallet = .empty
    @StateObject var viewModel = WalletConnectionViewModel()
    
    var body: some View {
        if viewModel.wallets.isEmpty {
            ScrollView {
                WalletConnectionOptionsView()
                    .environmentObject(viewModel)
                    .padding(.horizontal)
            }
        } else {
            WalletListContentView(allowSelection: false, selectedWallet: $_selectedWallet)
                .environmentObject(viewModel)
        }
    }
}

#if DEBUG
struct SettingsWalletListView_Previews : PreviewProvider {
    static var previews: some View {
        SettingsWalletListView()
    }
}
#endif
