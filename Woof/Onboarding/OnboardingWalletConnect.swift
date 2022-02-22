//
//  OnboardingWalletConnect.swift
//  Woof
//
//  Created by Mike Choi on 2/21/22.
//

import SwiftUI

struct OnboardingWalletConnect: View {
    @EnvironmentObject var connectionViewModel: WalletConnectionViewModel
    
    var body: some View {
        WalletConnectionContentView()
            .environmentObject(connectionViewModel)
            .onChange(of: connectionViewModel.wallets) { wallets in
                
            }
    }
}
