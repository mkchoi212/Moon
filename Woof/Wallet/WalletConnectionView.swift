//
//  WalletSelector.swift
//  Woof
//
//  Created by Mike Choi on 12/20/21.
//

import SwiftUI
import WalletConnectSwift

struct WalletConnectionOptionsView: View {
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    
    var body: some View {
        VStack {
            WalletConnectButton(image: Image(uiImage: .init(named: "metamask")!),
                                title: "Connect with Metamask") { uri in
                if let escaped = uri.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
                    return "https://metamask.app.link/wc?uri=\(escaped)"
                } else {
                    return nil
                }
            }
                                .environmentObject(viewModel)
            
            WalletConnectButton(image: Image(uiImage: .init(named: "rainbow")!),
                                title: "Connect with Rainbow") { uri in
                if let escaped = uri.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
                    return "https://rnbwapp.com/wc?uri=\(escaped)"
                } else {
                    return nil
                }
            }
                                .environmentObject(viewModel)
            
            Spacer()
        }
    }
}

struct WalletConnectionView: View {
    @State var rawEntryText: String = ""
    
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 18) {
                Spacer()
                
                TextField("Wallet address or ENS name", text: $rawEntryText)
                    .font(.system(size: 18, weight: .regular, design: .monospaced))
                    .padding(.bottom)
                
                Button {
                    // todo
                } label: {
                    Text("Add Wallet")
                        .foregroundColor(Color(uiColor: .systemBackground))
                        .font(.system(size: 18, weight: .medium))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 50).foregroundColor(.label))
                }
                .disabled(rawEntryText.isEmpty)
                .opacity(rawEntryText.isEmpty ? 0.5 : 1)
                
                Separator(text: "Or")
                
                WalletConnectionOptionsView()
                    .environmentObject(viewModel)
                
                Spacer()
            }
            .padding(.horizontal)
            .navigationTitle("Add Wallet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            })
        }
        .onChange(of: viewModel.walletAddresses) { newValue in
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct WalletSelector_Previews: PreviewProvider {
    static let walletViewModel = WalletConnectionViewModel()
    
    static var previews: some View {
        WalletConnectionView()
            .environmentObject(WalletSelector_Previews.walletViewModel)
        
        WalletConnectionView()
            .environmentObject(WalletSelector_Previews.walletViewModel)
            .preferredColorScheme(.dark)
    }
}
