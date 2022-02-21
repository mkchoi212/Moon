//
//  File.swift
//  Woof
//
//  Created by Mike Choi on 2/20/22.
//

import Foundation
import WalletConnectSwift

struct Wallet: Hashable {
    var address: String
    var connectionType: ConnectionType
   
    enum ConnectionType: Codable {
        case readonly, write(Session)
    }
    
    var session: Session? {
        if case let .write(session) = connectionType {
            return session
        } else {
            return nil
        }
    }
    
    static let empty = Wallet(address: "", connectionType: .readonly)
}

extension Wallet: Codable {
     enum CodingKeys: CodingKey {
         case address, connectionType
     }

     init(from decoder: Decoder) throws {
         let container = try decoder.container(keyedBy: CodingKeys.self)
         address = try container.decode(String.self, forKey: .address)
         connectionType = try container.decode(ConnectionType.self, forKey: .connectionType)
     }

     func encode(to encoder: Encoder) throws {
         var container = encoder.container(keyedBy: CodingKeys.self)
         try container.encode(address, forKey: .address)
         try container.encode(connectionType, forKey: .connectionType)
     }
}

extension Wallet: RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode(Wallet.self, from: data) else {
            return nil
        }
        
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        
        return result
    }
}

extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8) else {
            return "[]"
        }
        return result
    }
}
