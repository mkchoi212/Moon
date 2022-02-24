//
//  WalletSelector.swift
//  Woof
//
//  Created by Mike Choi on 12/20/21.
//

import SwiftUI
import WalletConnectSwift

struct PrimaryButtonModifier: ViewModifier {
    
    var backgroundColor: Color
    
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(RoundedRectangle(cornerRadius: 50).foregroundColor(backgroundColor))
    }
}

struct WalletConnectionContentView: View {
    @State var rawEntryText: String = ""
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    
    var body: some View {
        VStack(alignment: .center, spacing: 18) {
            Spacer()
            
            TextField("Wallet address or ENS name", text: $rawEntryText)
                .font(.system(size: 18, weight: .regular, design: .monospaced))
                .padding(.bottom)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            addWalletButton
            
            Separator(text: "Or")
            
            options
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Add Wallet")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder var addWalletButton: some View {
        Button {
            Task {
                await viewModel.connectReadOnlyWallet(input: rawEntryText)
            }
        } label: {
            addButton
                .modifier(PrimaryButtonModifier(backgroundColor: .label))
        }
        .disabled(rawEntryText.isEmpty)
        .opacity(rawEntryText.isEmpty ? 0.5 : 1)
    }
    
    @ViewBuilder var addButton: some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
                .tint(Color(uiColor: UIColor.systemBackground))
                .frame(height: 30)
        } else {
            Text("Add Wallet")
                .foregroundColor(Color(uiColor: .systemBackground))
                .font(.system(size: 18, weight: .medium))
        }
    }
    
    @ViewBuilder var options: some View {
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
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            WalletConnectionContentView()
                .environmentObject(viewModel)
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
        .onChange(of: viewModel.wallets) { newValue in
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
