//
//  WalletSelector.swift
//  Woof
//
//  Created by Mike Choi on 12/20/21.
//

import SwiftUI
import WalletConnectSwift

final class WalletViewModel: ObservableObject {
    var sessions: [Session] = []
    var walletToSessionMap: [String: Session] = [:]
    @Published var walletAddresses: [String] = []
    @Published var connectionError: Error?
    var uri: String?
    
    lazy var wc: WalletConnect = {
        WalletConnect(delegate: self)
    }()
    
    init() {
        refreshWallets(onMainThread: false)
    }
    
    func refreshWallets(onMainThread: Bool = true) {
        let refresh: () -> () = {
            self.sessions = UserDefaultsConfig.sessions
            var addresses = [String]()
            
            self.sessions.forEach { session in
                let accounts = session.walletInfo?.accounts ?? []
                addresses.append(contentsOf: accounts)
                
                accounts.forEach {
                    self.walletToSessionMap[$0] = session
                }
            }
            
            self.walletAddresses = addresses
        }
        
        if onMainThread {
            DispatchQueue.main.async {
                refresh()
            }
        } else {
            refresh()
        }
    }
    
    func connect() -> String? {
        do {
            let uri = try wc.connect()
            self.uri = uri
            return uri
        } catch {
            self.connectionError = error
            return nil
        }
    }
    
    func openWalletWithDelay(url: URL, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            UIApplication.shared.open(url, options: [:])
            completion()
        }
    }
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: .ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            if let output = filter.outputImage {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
    
    func walletProvider(of address: String) -> Session.ClientMeta? {
        walletToSessionMap[address]?.walletInfo?.peerMeta
    }
    
    func iconURL(of address: String) -> URL? {
        let provider = walletProvider(of: address)
        return provider?.icons.first
    }
}

extension WalletViewModel: WalletConnectDelegate {
    func failedToConnect() {
        print("FAILED")
        refreshWallets()
    }
    
    func didConnect() {
        print("CONNECTEd")
        refreshWallets()
    }
    
    func didDisconnect() {
        refreshWallets()
        print("DISCONNECTEd")
    }
    
    func didUpdate() {
        refreshWallets()
        print("UPDATED")
    }
}

struct WalletConnectButton: View {
    @EnvironmentObject var viewModel: WalletViewModel
    let image: Image
    let title: String
    let generateUniversalURL: (String) -> (String?)
    
    @State var isLoading = false
    
    var body: some View {
        Button {
            let uri = viewModel.connect()
            if let universalLink = universalLink(from: uri) {
                if UIApplication.shared.canOpenURL(universalLink) {
                    isLoading = true
                    
                    viewModel.openWalletWithDelay(url: universalLink) {
                        isLoading = false
                    }
                } else {
                    
                }
            } else {
                
            }
        } label: {
            HStack(spacing: 14) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                } else {
                    image
                        .resizable()
                        .frame(width: 30, height: 30)
                    Text(title)
                        .font(.system(size: 18, weight: .medium))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).foregroundColor(Color(uiColor: .secondarySystemBackground)))
            
        }
        .buttonStyle(.plain)
    }
    
    func universalLink(from uri: String?) -> URL? {
        guard let uri = uri,
              let rawUniversalLink = generateUniversalURL(uri)else {
                  return nil
              }
        
        return URL(string: rawUniversalLink)
    }
}

struct WalletConnectionOptionsView: View {
    @EnvironmentObject var viewModel: WalletViewModel

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
    @EnvironmentObject var viewModel: WalletViewModel
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible())]) {
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
                            Image(uiImage: .init(named: "wallet.pass.fill")!)
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
                    .padding()
                }
                .onTapGesture {
                    if selectedAddress == addr {
                        selectedAddress = nil
                    } else {
                        selectedAddress = addr
                    }
                }
            }
        }
    }
}

struct WalletSelector: View {
    @StateObject var walletViewModel = WalletViewModel()
    @State var selectedAddress: String?
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 15) {
                Text("Select a wallet")
                    .modifier(EditorHeaderModifier())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if walletViewModel.walletAddresses.isEmpty {
                    VStack {
                        Text("No wallets detected. Connect a wallet to get started.")
                            .font(.system(size: 15, design: .rounded))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                        
                        WalletConnectionOptionsView()
                            .environmentObject(walletViewModel)
                            .padding(.horizontal)
                    }
               } else {
                   ScrollView {
                       VStack(spacing: 35) {
                           WalletListContentView(selectedAddress: $selectedAddress)
                               .environmentObject(walletViewModel)
                           
                           NavigationLink {
                               WalletConnectionOptionsView()
                                   .environmentObject(walletViewModel)
                           } label: {
                               Label("Add a wallet", systemImage: "plus")
                                   .foregroundColor(.blue)
                                   .font(.system(size: 14))
                           }
                       }
                   }
               }
            }
            .navigationBarHidden(true)
            .padding(.top)
            .padding(.horizontal)
        }
    }
}


struct WalletSelector_Previews: PreviewProvider {
    static var previews: some View {
        WalletSelector(selectedAddress: nil)
        WalletSelector(selectedAddress: nil)
            .preferredColorScheme(.dark)
    }
}
