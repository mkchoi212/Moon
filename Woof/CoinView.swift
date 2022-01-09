//
//  WalletHomeView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI
import Shiny

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
    @EnvironmentObject var wallet: WalletModel
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(LinearGradient(colors: [Color(hex: "#191919"), Color(hex: "#050505")],
                                                startPoint: .top,
                                                endPoint: .bottom))
                .overlay(RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "#2a2a2a"), lineWidth: 2))
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
            
            VStack(alignment: .leading, spacing: 15) {
                Spacer()
                
                Text(wallet.formatCurrency(value: wallet.value))
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .shiny(.iridescent)
                
                Spacer()
                
                Text("0x9f8523C4DF59724Db6F1990aA064735cfDcd2EA1")
                    .lineLimit(1)
                    .foregroundColor(.white.opacity(0.7))
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(20)
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct WalletHomeView_Previews: PreviewProvider {
    static let env = WalletConnectionViewModel()
    
    static var previews: some View {
        CoinView()
            .environmentObject(env)
    }
}
