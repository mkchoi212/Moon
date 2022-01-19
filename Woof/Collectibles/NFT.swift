//
//  NFT.swift
//  Woof
//
//  Created by Mike Choi on 1/17/22.
//

import Foundation

struct NFT: Codable, Hashable, Identifiable {
    let tokenId: String
    let imageUrl: String?
    let backgroundColor: String?
    
    let name: String
    let externalLink: String?
    let assetContract: NFTContract?
//    let owner: Account
//    let traits: Dictionary
    
    var id: String {
        tokenId
    }
}

extension NFT {
    static func==(lhs: NFT, rhs: NFT) -> Bool {
        lhs.tokenId == rhs.tokenId
    }
}

struct NFTArray: Codable {
    let assets: [NFT]
}
