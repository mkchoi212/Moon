//
//  OnboardingWalletConnect.swift
//  Woof
//
//  Created by Mike Choi on 2/21/22.
//

import SwiftUI

struct OnboardingWalletConnect: View {
    @State var goToNextView = false
    @State var showSuccessToast = false
    @EnvironmentObject var connectionViewModel: WalletConnectionViewModel
    @EnvironmentObject var authModel: LocalAuthModel
    
    let haptic = UINotificationFeedbackGenerator()
    
    var body: some View {
        ScrollView {
            ZStack {
                NavigationLink(destination: PrivacyPermissionView().environmentObject(authModel), isActive: $goToNextView) {
                    EmptyView()
                }.hidden()
                
                WalletConnectionContentView()
                    .environmentObject(connectionViewModel)
                    .onChange(of: connectionViewModel.wallets) { wallets in
                        if wallets.isEmpty {
                            return
                        }
                        
                        haptic.notificationOccurred(.success)
                        showSuccessToast = true
                    }
            }
        }
        .toast(isPresenting: $showSuccessToast, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: "Wallet connected")
        }, completion:  {
            DispatchQueue.main.async {
                self.goToNextView = true
            }
        })
        .background(Color.tertiaryBackground)
    }
}
