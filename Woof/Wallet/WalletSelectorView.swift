//
//  WalletSelector.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI
import Introspect

struct WalletIconModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 50, height: 50)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct WalletIcon: View {
    var url: URL?
    
    var placeHolder: some View {
        Image(systemName: "wallet.pass.fill")
            .resizable()
            .foregroundStyle(Color.themePrimary)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8).foregroundColor(.lightBlue))
            .frame(width: 50, height: 50)
    }
    
    var body: some View {
        if let url = url {
            if url.absoluteString.contains("metamask-fox.svg") {
                Image("metamask")
                    .resizable()
                    .padding(6)
                    .background(Color(uiColor: .label))
                    .modifier(WalletIconModifier())
            } else {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .modifier(WalletIconModifier())
                } placeholder: {
                    placeHolder
                }
            }
        } else {
            placeHolder
        }
    }
}

struct WalletListContentView: View {
    @Binding var selectedAddress: String
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
                            .foregroundColor(.themeControl)
                    }
                }
                .onTapGesture {
                    if !allowSelection {
                        return
                    }
                    
                    selectedAddress = addr
                }
            }
            .onDelete(perform: delete)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.modalBackground)
        }
        .listStyle(.plain)
//        .toolbar {
//            EditButton()
//                .foregroundColor(.themeText)
//        }
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
//            VStack(alignment: .leading, spacing: 4) {
                WalletListContentView(selectedAddress: $viewModel.selectedAddress)
                    .environmentObject(viewModel)

//                Button {
//                    presentWalletConnectionView = true
//                } label: {
//                    Text("Add an existing wallet")
//                        .font(.system(size: 15))
//                        .foregroundColor(.themeText)
//                }
//                .padding(.horizontal)
//            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.modalBackground)
            .navigationTitle("Wallets")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {                
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
        .systemBottomSheet(isPresented: $presentWalletConnectionView, detents: .constant([.large()])) {
            WalletConnectionView()
                .environmentObject(viewModel)
                .navigationBarTitleDisplayMode(.inline)
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
