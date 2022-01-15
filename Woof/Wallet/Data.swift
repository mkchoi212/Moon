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
    @AppStorage("current.wallet.address") var currentWalletAddress: String = "" {
        didSet {
            print("asdf")
        }
    }
    
    @Published var network = Network()
    @Published var portfolio: Portfolio?
    @Published var tokens: [Token] = []
    @Published var objects: [OpenSeaAsset] = []
    @Published var transactions: [Transaction] = []
    
    @Published var loadingPortfolio = true
    @Published var loadingTokens = true
    @Published var loadingObjects = true
    @Published var loadingTransactions = true
    
    let qrQueue = DispatchQueue(label: "com.woof.qr.code.generation")
    var walletQRCodeData: Data?
    
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
    
        qrQueue.async {
            self.walletQRCodeData = self.getQRCodeDate(text: self.currentWalletAddress)
        }
    }
    
    func getQRCodeDate(text: String) -> Data? {
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            return nil
        }
        
        let data = text.data(using: .ascii, allowLossyConversion: false)
        filter.setValue(data, forKey: "inputMessage")
        guard let ciimage = filter.outputImage else {
            return nil
        }
        
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        let scaledCIImage = ciimage.transformed(by: transform)
        let uiimage = UIImage(ciImage: scaledCIImage)
        return uiimage.pngData()!
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
            self.loadingObjects = true
            self.loadingPortfolio = true
            self.loadingTransactions = true
            
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
