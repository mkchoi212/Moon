//
//  NFT.swift
//  Woof
//
//  Created by Mike Choi on 1/17/22.
//

import Foundation

struct Trait: Codable, Hashable {
    let traitType: String
    let value: String
    let displayType: String?
    let maxValue: Int?
    let traitCount: Int?
    let order: Int?
}

struct OpenSeaUser: Codable, Hashable {
    struct Username: Codable, Hashable {
        let username: String?
    }
    
    let user: Username?
    let profileImageUrl: String?
    let address: String
}

struct NFT: Codable, Hashable, Identifiable {
    let owner: OpenSeaUser
    let creator: OpenSeaUser
    let tokenId: String
    let imageUrl: String?
    
    let backgroundColor: String?
    
    let name: String
    let externalLink: String?
    let permalink: String?
    let assetContract: NFTContract?
    let description: String?
    let traits: [Trait]
    
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
