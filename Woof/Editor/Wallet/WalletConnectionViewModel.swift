//
//  WalletConnectionViewModel.swift
//  Woof
//
//  Created by Mike Choi on 12/21/21.
//

import SwiftUI
import WalletConnectSwift

final class WalletConnectionViewModel: ObservableObject {
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

extension WalletConnectionViewModel: WalletConnectDelegate {
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
