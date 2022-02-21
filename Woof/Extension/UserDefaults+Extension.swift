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
    
    @UserDefault("theme", defaultValue: nil)
    static var theme: String?
}
