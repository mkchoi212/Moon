//
//  SettingsWalletListView.swift
//  Woof
//
//  Created by Mike Choi on 12/22/21.
//

import Foundation
import SwiftUI

struct SettingsWalletListView: View {
    @State var _selectedAddr: String = ""
    @StateObject var viewModel = WalletConnectionViewModel()
    
    var body: some View {
        if viewModel.walletAddresses.isEmpty {
            ScrollView {
                WalletConnectionOptionsView()
                    .environmentObject(viewModel)
                    .padding(.horizontal)
            }
        } else {
            WalletListContentView(allowSelection: false, selectedAddress: $_selectedAddr)
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
