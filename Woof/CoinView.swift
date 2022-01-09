//
//  WalletHomeView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI

struct WalletHeader: View {
    @Binding var presentWalletSelector: Bool
    @EnvironmentObject var walletViewModel: WalletConnectionViewModel
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            Button {
                presentWalletSelector = true
            } label: {
                CircleImageView(backgroundColor: .themeText,
                                icon: Image(systemName: "moon"))
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("junsoo.eth")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.themeText)
                
                Text("$14,231.10")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.themeText)
            }
            
            Spacer()
            
            Button {
            } label: {
                HStack {
                    Text("Ethereum")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.themeText)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.themeText)
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
        .background(Color.themePrimary)
    }
}

struct CoinView: View {
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    
    var body: some View {
        Text("asdf")
    }
}

struct WalletHomeView_Previews: PreviewProvider {
    static let env = WalletConnectionViewModel()
    
    static var previews: some View {
        CoinView()
            .environmentObject(env)
    }
}
