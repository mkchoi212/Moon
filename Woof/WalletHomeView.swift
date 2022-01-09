//
//  WalletHomeView.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI
import BottomSheet

struct WalletHomeContentView: View {
    var body: some View {
        List {
            ForEach(0...10, id: \.self) { i in
                Text("asdf")
            }
        }
    }
}

struct WalletHeader: View {
    @Binding var presentWalletSelector: Bool
    @EnvironmentObject var walletViewModel: WalletConnectionViewModel
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            Button {
               presentWalletSelector = true
            } label: {
                CircleImageView(backgroundColor: .white,
                                icon: Image(systemName: "moon"))
            }
            .frame(width: 40, height: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("junsoo.eth")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundColor(.white)
                
                Text("$14,231.10")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Button {
            } label: {
                HStack {
                    Text("Ethereum")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundColor(.white)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                }
                .padding(6)
                .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(.white, style: .init(lineWidth: 0.5))
                )
            }
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 15)
        .background(Color.themePrimary)
    }
}

struct WalletHomeView: View {
    @Binding var presentWalletSelector: Bool
    @EnvironmentObject var walletViewModel: WalletConnectionViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            WalletHeader(presentWalletSelector: $presentWalletSelector)
                .environmentObject(walletViewModel)
            
            WalletHomeContentView()
        }
        .onAppear {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
}

struct WalletHomeView_Previews: PreviewProvider {
    static var previews: some View {
        WalletHomeView(presentWalletSelector: .constant(false))
    }
}
