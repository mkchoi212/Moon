//
//  OpenSea.swift
//  Woof
//
//  Created by Mike Choi on 1/17/22.
//

import Foundation
import SwiftUI

typealias CollectionTable = [NFTCollection: [NFT]]

final class OpenSea: ObservableObject {
    @AppStorage("current.wallet.address") var currentWalletAddress: String = ""
    
    @Published var isNotAvailable = false
    @Published var isLoading = true
    @Published var collectionTable: CollectionTable = [:]
    
    let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetch() {
        isLoading = true
        
        Task {
            do {
                let collections = try await fetchCollections()
                for collection in collections {
                    guard let slug = collection.slug else {
                        collectionTable[collection] = []
                        continue
                    }
                    
                    let collectionAssets = try await fetchNFTs(in: slug)
                    DispatchQueue.main.async {
                        self.collectionTable[collection] = collectionAssets
                    }
                }
            } catch let err {
                print(err)
                
                DispatchQueue.main.async {
                    self.isNotAvailable = true
                }
            }
            
            DispatchQueue.main.async {
                self.isLoading = false
            }
        }
    }
}

extension OpenSea {
    private func fetchCollections() async throws -> [NFTCollection] {
        var urlComponents = URLComponents(string: "https://api.opensea.io/api/v1/collections")!
        urlComponents.queryItems = [
            .init(name: "asset_owner", value: "0x9f8523C4DF59724Db6F1990aA064735cfDcd2EA1"),
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15", forHTTPHeaderField: "user-agent")
        
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        return try decoder.decode([NFTCollection].self, from: data)
    }
    
    private func fetchNFTs(in collectionSlug: String) async throws -> [NFT] {
        var urlComponents = URLComponents(string: "https://api.opensea.io/api/v1/assets")!
        urlComponents.queryItems = [
            .init(name: "owner", value: currentWalletAddress),
            .init(name: "collection", value: collectionSlug)
        ]
        
        var request = URLRequest(url: urlComponents.url!)
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.2 Safari/605.1.15", forHTTPHeaderField: "user-agent")
        
        let (data, _) = try await URLSession.shared.data(for: request, delegate: nil)
        let array = try decoder.decode(NFTArray.self, from: data)
        return array.assets
    }
}
