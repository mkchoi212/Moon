//
//  WalletConnect.swift
//  Woof
//
//  Created by Mike Choi on 12/21/21.
//

import Foundation
import SwiftUI
import WalletConnectSwift

protocol WalletConnectDelegate {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
    func didUpdate()
}

final class WalletConnect {
    var client: Client!
    var session: Session!
    var delegate: WalletConnectDelegate

    let iconURL = "https://pbs.twimg.com/profile_images/1473169204610502656/wrHEpsx4_400x400.jpg"
    
    @AppStorage("current.wallet") var selectedWallet: Wallet = .empty
    @AppStorage("wallets") var wallets: [Wallet] = []
    
    init(delegate: WalletConnectDelegate) {
        self.delegate = delegate
    }

    func connect() throws -> String? {
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: URL(string: "https://safe-walletconnect.gnosis.io/")!,
                           key: try! randomKey())
        let clientMeta = Session.ClientMeta(name: "Woof",
                                            description: "Crypto automation no-code app",
                                            icons: [URL(string: iconURL)!],
                                            url: URL(string: "https://safe.gnosis.io")!)
        
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)

        print("WalletConnect URL: \(wcUrl.absoluteString)")

        try client.connect(to: wcUrl)
        return wcUrl.absoluteString
    }

    func reconnectIfNeeded() {
//        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
//            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
//            client = Client(delegate: self, dAppInfo: session.dAppInfo)
//            try? client.reconnect(to: session)
//        }
    }

    private func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            // we don't care in the example app
            enum TestError: Error {
                case unknown
            }
            throw TestError.unknown
        }
    }
}

extension WalletConnect: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate.failedToConnect()
    }

    func client(_ client: Client, didConnect url: WCURL) {
        delegate.didConnect()
    }

    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        
        let existingWalletIdx = wallets.firstIndex { wallet in
            wallet.session?.url == session.url
        }
        if let existingWalletIdx = existingWalletIdx {
            wallets.remove(at: existingWalletIdx)
        }
       
        let newAddr = session.walletInfo?.accounts.first ?? ""
        let newWallet = Wallet(address: newAddr, connectionType: .write(session))
        
        wallets.append(newWallet)
        selectedWallet = newWallet
        
        NotificationCenter.default.post(name: .init(rawValue: "refresh.selected.wallet"), object: nil)
        delegate.didConnect()
    }

    func client(_ client: Client, didDisconnect session: Session) {
        let idx = wallets.firstIndex {
            $0.session?.url == session.url
        }
        
        if let idx = idx {
            wallets.remove(at: idx)
        }
        
        delegate.didDisconnect()
    }

    func client(_ client: Client, didUpdate session: Session) {
        delegate.didUpdate()
    }
}
