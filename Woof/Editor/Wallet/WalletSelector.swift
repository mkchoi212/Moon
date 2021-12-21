//
//  WalletSelector.swift
//  Woof
//
//  Created by Mike Choi on 12/20/21.
//

import SwiftUI
import WalletConnectSwift

final class WalletViewModel: ObservableObject {
    @Published var wallets: [Session] = UserDefaultsConfig.sessions
    @Published var connectionError: Error?
    var uri: String?
    
    lazy var wc: WalletConnect = {
        WalletConnect(delegate: self)
    }()
    
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
}

extension WalletViewModel: WalletConnectDelegate {
    func refreshWallets() {
        DispatchQueue.main.async {
            self.wallets = UserDefaultsConfig.sessions
        }
    }
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

struct WalletSelector: View {
    @StateObject var walletViewModel = WalletViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center, spacing: 15) {
                Text("Select a wallet")
                    .modifier(EditorHeaderModifier())
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if walletViewModel.wallets.isEmpty {
                    Text("No wallets detected. Connect a wallet to get started.")
                        .font(.system(size: 15, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(.secondary)
                    
                    Spacer()
                    
                    VStack {
                        WalletConnectButton(image: Image(uiImage: .init(named: "metamask")!),
                                            title: "Connect to your Metamask wallet") { uri in
                            if let escaped = uri.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
                                return "https://metamask.app.link/wc?uri=\(escaped)"
                            } else {
                                return nil
                            }
                        }
                        .environmentObject(walletViewModel)
                        
                        WalletConnectButton(image: Image(uiImage: .init(named: "rainbow")!),
                                            title: "Connect to your Rainbow wallet") { uri in
                            if let escaped = uri.addingPercentEncoding(withAllowedCharacters: .alphanumerics) {
                                return "https://rnbwapp.com/wc?uri=\(escaped)"
                            } else {
                                return nil
                            }
                        }
                        .environmentObject(walletViewModel)
                    }
                    
                    Spacer()
                    
                } else {
                    LazyVGrid(columns: [GridItem(.flexible())]) {
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
        WalletSelector()
        WalletSelector()
            .preferredColorScheme(.dark)
    }
}
