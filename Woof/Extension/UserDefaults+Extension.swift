//
//  UserDefaults+Extension.swift
//  Woof
//
//  Created by Mike Choi on 12/21/21.
//

import Foundation
import WalletConnectSwift

final class UserDefaultsConfig: NSObject {
    
    static let shared = UserDefaultsConfig()
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    
    @UserDefault("wallet.sessions", defaultValue: [])
    static var sessionsDataArray: [Data]
    static var sessions: [Session] {
        get {
            return sessionsDataArray.compactMap {
                try? UserDefaultsConfig.shared.decoder.decode(Session.self, from: $0)
            }
        }
        set {
            sessionsDataArray = newValue.compactMap {
                try? UserDefaultsConfig.shared.encoder.encode($0)
            }
        }
    }
}
