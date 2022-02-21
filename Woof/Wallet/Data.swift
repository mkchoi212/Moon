//
//  Data.swift
//  Woof
//
//  Created by Mike Choi on 1/9/22.
//

import Foundation
import SocketIO
import Combine
import SwiftUI

class WalletModel: ObservableObject {
    @AppStorage("current.wallet.address") var currentWalletAddress: String = ""
    
    @Published var network = Network()
    @Published var portfolio: Portfolio?
    @Published var tokens: [Token] = []
    @Published var transactions: [Transaction] = []
    
    @Published var loadingPortfolio = true
    @Published var loadingTokens = true
    @Published var loadingTransactions = true
    
    let qrGenerator = QRCodeGenerator()
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .custom({ keys in
            guard let rawValue = keys.last?.stringValue else {
                // unknown case
                return AnyKey(stringValue: "")!
            }
            
            let split = rawValue.split(separator: "_").map(String.init).enumerated().map { (idx, component) -> String in
                if idx == 0 {
                    return component
                } else {
                    if component.first?.isNumber ?? false {
                        return component
                    } else {
                        return component.capitalized
                    }
                }
            }
            
            return AnyKey(stringValue: split.joined())!
        })
        return decoder
    }()
    
    init() {
        reload(reset: false, refresh: false)
        qrGenerator.currentWalletAddress = currentWalletAddress
    }
  
    func copyAddressToPasteboard() {
        UIPasteboard.general.string = currentWalletAddress
    }
    
    func formatAddress(address: String) -> String {
        return address.prefix(6) + "..." + address.suffix(4)
    }
    
    func reload(reset: Bool, refresh: Bool) {
        if reset {
            network.disconnect()
            
            self.loadingTokens = true
            self.loadingPortfolio = true
            self.loadingTransactions = true
            
            self.tokens = []
            self.transactions = []
            network.connect()
        }
        
        if refresh {
            network.disconnect()
            // refresh wallet
            network.connect()
        }
        
        // reload wallet after updating address
        addressSocket.on(clientEvent: .connect) { data, ack in
            self.fetchAssets()
        }
    }
}

extension WalletModel {
    func transactions(for token: Token) -> [Transaction] {
        transactions.filter {
            $0.change?.asset.id == token.id
        }
    }
}

extension WalletModel {
    func fetchAssets() {
        if self.currentWalletAddress != "" {
            addressSocket.emit("get", ["scope": ["assets", "portfolio", "transactions"], "payload": ["address": self.currentWalletAddress, "currency": "usd"]])

            addressSocket.on("received address assets") { data, ack in
                var tokensArray: [Token] = []
                print("received assets")
                
                DispatchQueue.main.async {
                    if let array = data as? [[String: AnyObject]], let firstDict = array.first {
                        let assets = firstDict["payload"]!["assets"]! as! [String: AnyObject]
                        
                        for asset in assets {
                            var assetData = asset.value["asset"] as! [String: Any]
                            assetData["quantity"] = asset.value["quantity"] as! String
                            let priceData = assetData["price"] as? [String: Any]
                           
                            if priceData != nil,
                               let assetBinary = try? JSONSerialization.data(withJSONObject: assetData, options: .fragmentsAllowed),
                               let token = try? self.decoder.decode(Token.self, from: assetBinary) {
                                tokensArray.append(token)
                            }
                        }
                        
                        self.loadingTokens = false
                        self.tokens = tokensArray
                    }
                }
            }
            
            addressSocket.on("received address portfolio") { data, ack in
                print("received portfolio")
                DispatchQueue.main.async {
                    if let array = data as? [[String: AnyObject]],
                       let firstDict = array.first,
                       let portfolioDict = firstDict["payload"]!["portfolio"]! as? [String: AnyObject],
                       let portfolioData = try? JSONSerialization.data(withJSONObject: portfolioDict, options: .fragmentsAllowed),
                       let portfolio = try? self.decoder.decode(Portfolio.self, from: portfolioData) {
                        self.portfolio = portfolio
                        self.loadingPortfolio = false
                    }
                }
            }
            
            addressSocket.on("received address transactions") { data, ack in
                var transactionsArray: [Transaction] = []
                print("received transactions")
                
                DispatchQueue.main.async {
                    if let array = data as? [[String: AnyObject]], let firstDict = array.first {
                        let transactions = firstDict["payload"]!["transactions"]! as! [AnyObject]
                        
                        for transaction in transactions {
                            if let transDict = transaction as? [String: AnyObject],
                               let transData = try? JSONSerialization.data(withJSONObject: transDict, options: .fragmentsAllowed),
                               let trans = try? self.decoder.decode(Transaction.self, from: transData) {
                                transactionsArray.append(trans)
                            }
                        }
                        
                        self.transactions = transactionsArray
                        self.loadingTransactions = false
                    }
                }
            }
        } else {
            self.loadingTokens = false
            self.loadingPortfolio = false
            self.loadingTransactions = false
        }
    }
}

let oneETHinWEI: Double = 1000000000000000000 // 18 decimals to divide amounts by

struct ReverseENSLookupResponse: Codable {
    var address: String
}

let manager = SocketManager(socketURL: URL(string: "wss://api-v4.zerion.io")!, config: [.log(false), .extraHeaders(["Origin": "https://localhost:3000"]), .forceWebsockets(true), .connectParams( ["api_token": "Demo.ukEVQp6L5vfgxcz4sBke7XvS873GMYHy"]), .version(.two), .secure(true)])

let socket = manager.defaultSocket
let addressSocket = manager.socket(forNamespace: "/address")

class Network: ObservableObject {
    init() {
        connect()
    }
    
    func connect() {
        addressSocket.connect()
    }
    
    func disconnect() {
        addressSocket.disconnect()
        addressSocket.removeAllHandlers()
    }
}
