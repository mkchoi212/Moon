//
//  Data.swift
//  Woof
//
//  Created by Mike Choi on 1/9/22.
//

import Foundation
import CoreGraphics
import SocketIO
import Combine
import SwiftUI

class WalletModel: ObservableObject {
    @AppStorage("current.wallet.address") var currentWalletAddress: String = ""
    @Published var network = Network()
    @Published var value: NSNumber = 0
    @Published var tokens: [Token] = []
    @Published var objects: [OpenSeaAsset] = []
    @Published var transactions: [Transaction] = []
    
    @Published var loadingPortfolio = true
    @Published var loadingTokens = true
    @Published var loadingObjects = true
    @Published var loadingTransactions = true
    
    lazy var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    init() {
        reload(reset: false, refresh: false)
    }
    
    func formatCurrency(value: NSNumber) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency

        let total = Double(truncating: value)

        return formatter.string(from: NSNumber(value: total)) ?? "$0"
    }
    
    func formatAddress(address: String) -> String {
        return address.prefix(6) + "..." + address.suffix(4)
    }
    
    func reload(reset: Bool, refresh: Bool) {
        if reset {
            network.disconnect()
            
            self.loadingTokens = true
            self.loadingObjects = true
            self.loadingPortfolio = true
            self.loadingTransactions = true
            
            self.value = 0
            self.tokens = []
            self.objects = []
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
        
        self.fetchObjects()
    }
    
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
                            let assetData = asset.value["asset"] as! [String: AnyObject]
                            let priceData = assetData["price"] as? [String: AnyObject]
                           
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
                    if let array = data as? [[String: AnyObject]], let firstDict = array.first {
                        let assets = firstDict["payload"]!["portfolio"]! as! [String: AnyObject]
                        self.value = assets["total_value"] as! NSNumber
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
                            let transactionData = transaction as! [String: AnyObject]
                            let id = transactionData["id"] as! String
                            let changes = transactionData["changes"] as! [AnyObject]
                            let asset = changes.first
                            
                            let assetObject = asset?["asset"] as? [String: AnyObject]
                            var token: Token? = nil
                            if assetObject != nil {
                                let tokenID = assetObject?["id"] as? String
                                let name = assetObject?["name"] as? String
                                let symbol = assetObject?["symbol"] as? String
                                let iconURL = assetObject?["icon_url"] as? String
                                token = Token(id: tokenID ?? "0", name: name ?? "", symbol: symbol ?? "", quantity: nil, price: nil, iconURL: iconURL)
                            }
                            
                            let value = asset?["value"] as? Double
                            let price = asset?["price"] as? Double
                            let type = transactionData["type"] as! String
                            let mined_at = transactionData["mined_at"] as! Int
                            let hash = transactionData["hash"] as! String
                            let status = transactionData["status"] as! String
                            let block_number = transactionData["block_number"] as! Int
                            let address_from = transactionData["address_from"] as? String
                            let address_to = transactionData["address_to"] as? String
                            
                            var fee: Fee? = nil
                            let feeObject = transactionData["fee"] as? [String: AnyObject]
                            if feeObject != nil {
                                let feeValue = feeObject?["value"] as? Double
                                let feePrice = feeObject?["price"] as? Double
                                fee = Fee(value: feeValue ?? 0, price: feePrice ?? 0)
                            }
                            
                            let transactionObject = Transaction(id: id, token: token, value: value, price: price, type: type, mined_at: mined_at, hash: hash, status: status, block_number: block_number, address_from: address_from, address_to: address_to, fee: fee)
                            transactionsArray.append(transactionObject)
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
    
    func fetchObjects() {
        if self.currentWalletAddress != "" {
            guard let url = URL(string: "https://api.opensea.io/api/v1/assets?limit=50&format=json&owner=\(self.currentWalletAddress)") else {
                print("Invalid URL")
                return
            }
                    
            let request = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let decodedResponse = try? JSONDecoder().decode(OpenSeaAssetsResponse.self, from: data) {
                        // we have good data – go back to the main thread
                        DispatchQueue.main.async {
                            // update our UI
                            self.objects = decodedResponse.assets
                            self.loadingObjects = false
                        }

                        return
                    }
                }

                // if we're still here it means there was a problem
                print("failed: \(error?.localizedDescription ?? "Unknown error")")
            }.resume()
        } else {
            self.loadingObjects = false
        }
    }
}

let oneETHinWEI: Double = 1000000000000000000 // 18 decimals to divide amounts by

struct ReverseENSLookupResponse: Codable {
    var address: String
}

struct OpenSeaAssetsResponse: Codable {
    var assets: [OpenSeaAsset]
}

class OpenSeaAsset: Codable, ObservableObject {
    var id: Int
    var image_url: String
    var name: String?
    var external_link: String?
    var traits: [OpenSeaAssetTrait]
    var description: String?
    var permalink: String
    
    func isSVG() -> Bool {
        return self.image_url.suffix(3) == "svg"
    }
}

struct OpenSeaAssetTrait: Codable {
    var trait_type: String
    var value: String
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.trait_type = try container.decode(String.self, forKey: .trait_type)
        do {
            self.value = try container.decode(String.self, forKey: .value)
        } catch DecodingError.typeMismatch {
            let value = try container.decode(Int.self, forKey: .value)
            self.value = "\(value)"
        }
    }
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
