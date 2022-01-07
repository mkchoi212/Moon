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
                                title: "Connect to your Metamask wallet") { uri in
                if let escaped = uri.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
                    return "https://metamask.app.link/wc?uri=\(escaped)"
                } else {
                    return nil
                }
            }
                                .environmentObject(viewModel)
            
            WalletConnectButton(image: Image(uiImage: .init(named: "rainbow")!),
                                title: "Connect to your Rainbow wallet") { uri in
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

struct WalletListContentView: View {
    @Binding var selectedAddress: String?
    var allowSelection = false
    
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.walletAddresses, id: \.self) { addr in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 12)
                        .foregroundColor(Color(uiColor: .secondarySystemGroupedBackground))
                    
                    HStack(alignment: .center, spacing: 8) {
                        if let iconURL = viewModel.iconURL(of: addr) {
                            AsyncImage(url: iconURL) { image in
                                image
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            } placeholder: {
                                RoundedRectangle(cornerRadius: 4)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.lightGray)
                            }
                        } else {
                            Image(systemName: "wallet.pass.fill")
                                .resizable()
                                .foregroundStyle(.blue)
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.lightBlue))
                                .frame(width: 50, height: 50)
                        }
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text(addr)
                                .font(.custom("Menlo", size: 15))
                            
                            if let providerName = viewModel.walletProvider(of: addr)?.name {
                                Text(providerName)
                                    .foregroundColor(.secondary)
                                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                            }
                        }
                        
                        if addr == selectedAddress {
                            Image(systemName: "checkmark")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundColor(.blue)
                        }
                    }
                }
                .onTapGesture {
                    if !allowSelection {
                        return
                    }
                    
                    if selectedAddress == addr {
                        selectedAddress = nil
                    } else {
                        selectedAddress = addr
                    }
                }
            }
            
            NavigationLink {
                SecondaryWalletConnectorView()
                    .navigationBarTitleDisplayMode(.inline)
                    .environmentObject(viewModel)
            } label: {
                Label("Add a wallet", systemImage: "plus")
                    .foregroundColor(.blue)
            }
        }
        .listStyle(.insetGrouped)
    }
}

struct SecondaryWalletConnectorView: View {
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center, spacing: 15) {
            Text("Add an additional wallet")
                .modifier(EditorHeaderModifier())
                .frame(maxWidth: .infinity, alignment: .leading)
            
            WalletConnectionOptionsView()
                .environmentObject(viewModel)
            
            Spacer()
        }
        .padding(.horizontal)
        .onChange(of: viewModel.walletAddresses) { newValue in
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct WalletSelectorView: View {
    @StateObject var walletViewModel = WalletConnectionViewModel()
    @State var selectedAddress: String?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 15) {
                Text("Select a wallet")
                    .modifier(EditorHeaderModifier())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if walletViewModel.walletAddresses.isEmpty {
                    VStack {
                        Text("No wallets detected. Connect a wallet to get started.")
                            .font(.system(size: 15, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        WalletConnectionOptionsView()
                            .environmentObject(walletViewModel)
                    }
                    .padding(.horizontal)
                } else {
                    WalletListContentView(selectedAddress: $selectedAddress)
                        .environmentObject(walletViewModel)
                }
            }
            .navigationBarHidden(true)
            .padding(.top)
        }
    }
}


struct WalletSelector_Previews: PreviewProvider {
    static var previews: some View {
        WalletSelectorView(selectedAddress: nil)
        WalletSelectorView(selectedAddress: nil)
            .preferredColorScheme(.dark)
    }
}
