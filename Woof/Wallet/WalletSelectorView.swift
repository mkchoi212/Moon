//
//  WalletSelector.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI

struct WalletIcon: View {
    var url: URL?
    
    var body: some View {
        if let url = url {
            AsyncImage(url: url) { image in
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
                .foregroundStyle(Color.themePrimary)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.lightBlue))
                .frame(width: 50, height: 50)
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
                HStack(alignment: .center, spacing: 15) {
                    WalletIcon(url: viewModel.iconURL(of: addr))
                  
                    Text(addr)
                        .font(.system(size: 15, weight: .regular, design: .monospaced))
                
                    if addr == selectedAddress {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.themePrimary)
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
            .onDelete(perform: delete)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .toolbar {
            EditButton()
        }
    }
    
    func delete(at offsets: IndexSet) {
        print("Delete")
    }
}

struct WalletSelectorView: View {
    @State var presentWalletConnectionView = false
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 4) {
                WalletListContentView(selectedAddress: $viewModel.selectedAddress)
                    .environmentObject(viewModel)
                
                Spacer()
                
                Button {
                    presentWalletConnectionView = true
                } label: {
                    Text("Add an existing wallet")
                        .font(.system(size: 15))
                        .foregroundColor(.themePrimary)
                }
                .padding(.horizontal)
            }
            .navigationTitle("Wallets")
            .navigationBarTitleDisplayMode(.inline)
        }
        .bottomSheet(isPresented: $presentWalletConnectionView, detents: .constant([.large()])) {
            NavigationView {
                WalletConnectionView()
                    .environmentObject(viewModel)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct WalletSelectorView_Previews: PreviewProvider {
    static let walletViewModel = WalletConnectionViewModel()
    
    static var previews: some View {
        WalletSelectorView()
            .environmentObject(WalletSelector_Previews.walletViewModel)
    }
}
