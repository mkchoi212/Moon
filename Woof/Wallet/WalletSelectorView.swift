//
//  WalletSelector.swift
//  Woof
//
//  Created by Mike Choi on 1/8/22.
//

import SwiftUI
import Introspect
import zlib

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
                // replace with diff image loader?
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .modifier(WalletIconModifier())
                } placeholder: {
                    placeHolder
                }
                .animation(nil, value: UUID())
            }
        } else {
            placeHolder
        }
    }
}

struct WalletRow: View {
    let iconURL: URL?
    let addr: String
    @Binding var selectedAddress: String
    
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            WalletIcon(url: iconURL)
            
            let isSelected = (addr == selectedAddress)
            
            Text(addr)
                .font(.system(size: 15, weight: .semibold, design: .monospaced))
                .foregroundColor(isSelected ? .blue : .label)
                .multilineTextAlignment(.leading)
            
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.blue)
            }
        }
    }
}

struct ConnectWalletRow: View {
    var body: some View {
        HStack(alignment: .center, spacing: 15) {
            Image(systemName: "plus")
                .font(.system(size: 24, weight: .semibold))
                .foregroundStyle(Color(uiColor: .label))
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.lightGray, lineWidth: 1))
                .frame(width: 50, height: 50)
            
            Text("Connect wallet")
                .font(.system(size: 15, weight: .semibold, design: .default))
            
            Spacer()
        }
    }
}

struct WalletListContentView: View {
    var allowSelection = false
    
    @Binding var selectedAddress: String
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    
    var body: some View {
        List {
            ForEach(viewModel.walletAddresses, id: \.self) { addr in
                WalletRow(iconURL: viewModel.iconURL(of: addr),
                          addr: addr,
                          selectedAddress: allowSelection ? $selectedAddress : .constant(""))
            }
            .onDelete(perform: delete)
            .listRowSeparator(.hidden)
            .listRowBackground(Color.modalBackground)
        }
        .listStyle(.plain)
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
            WalletListContentView(selectedAddress: $viewModel.selectedAddress)
                .environmentObject(viewModel)
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

struct StackedWalletSelectorView: View {
    @Binding var presentSheet: Bool
    @EnvironmentObject var viewModel: WalletConnectionViewModel
    
    let feedback = UISelectionFeedbackGenerator()
    var connectWallet: () -> ()
    
    var body: some View {
        VStack(spacing: 8) {
            ForEach(viewModel.walletAddresses, id: \.self) { addr in
                Button {
                    feedback.selectionChanged()
                    viewModel.selectedAddress = addr
                    presentSheet = false
                } label: {
                    WalletRow(iconURL: viewModel.iconURL(of: addr),
                              addr: addr,
                              selectedAddress: viewModel.$selectedAddress)
                        .padding()
                }
                
                Separator()
            }
            
            Button {
                presentSheet = false
                feedback.selectionChanged()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    connectWallet()
                }
            } label: {
                ConnectWalletRow()
                    .padding()
            }
        }
    }
}

struct WalletSelectorView_Previews: PreviewProvider {
    static let walletViewModel = WalletConnectionViewModel()
    
    static var previews: some View {
        WalletSelectorView()
            .environmentObject(WalletSelector_Previews.walletViewModel)
        
        WalletRow(iconURL: nil, addr: "0x1321231029asdfasdfasdfadfsdfas3810928309123", selectedAddress: .constant("asdf"))
        
        ConnectWalletRow()
    }
}
