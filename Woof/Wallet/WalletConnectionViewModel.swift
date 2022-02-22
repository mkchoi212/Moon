//
//  WalletConnectionViewModel.swift
//  Woof
//
//  Created by Mike Choi on 12/21/21.
//

import Combine
import SwiftUI
import WalletConnectSwift

final class WalletConnectionViewModel: ObservableObject {
    lazy var wc: WalletConnect = {
        WalletConnect(delegate: self)
    }()
    
    let reverseENS = ReverseENS()
    
    var sessions: [Session] = []
    var walletToSessionMap: [String: Session] = [:]
    var uri: String?
    
    @Published var isLoading = false
    @Published var connectionError: Error?
    @Published var selectedSession: Session?
    @AppStorage("wallets") var wallets: [Wallet] = []
    @AppStorage("current.wallet") var selectedWallet: Wallet = .empty
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        let addr = selectedWallet.address
        selectedSession = walletToSessionMap[addr]
        
        NotificationCenter.default.publisher(for: .init(rawValue: "refresh.selected.wallet"), object: nil)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.selectedSession = self.walletToSessionMap[addr]
            }
            .store(in: &cancellables)
    }
    
    func connectReadOnlyWallet(input: String) async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        
        if input.lowercased().contains(".eth") {
            let address = try? await reverseENS.reverseENSLookup(ensName: input)
            if let address = address {
                addWallet(wallet: Wallet(address: address, connectionType: .readonly))
            } else {
                connectionError = "Failed to lookup ENS name"
            }
        } else {
            addWallet(wallet: Wallet(address: input, connectionType: .readonly))
        }
       
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    private func addWallet(wallet: Wallet) {
        DispatchQueue.main.async {
            self.wallets.append(wallet)
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
    }
    
    func didConnect() {
        print("CONNECTEd")
    }
    
    func didDisconnect() {
        print("DISCONNECTEd")
    }
    
    func didUpdate() {
        print("UPDATED")
    }
}
