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
    
    static var random: NFT {
        NFT(owner: .init(user: .init(username: "adamtrannews"), profileImageUrl: "https://storage.googleapis.com/opensea-static/opensea-profile/19.png", address: "0x7becee3d6a7c1b7355fc04af63ec9a2f0a583436"), creator: .init(user: .init(username: "adamtrannews"), profileImageUrl: "https://storage.googleapis.com/opensea-static/opensea-profile/19.png", address: "0x7becee3d6a7c1b7355fc04af63ec9a2f0a583436"),
            tokenId: UUID().uuidString,
            imageUrl: "https://lh3.googleusercontent.com/jAnoAAC4aNNREN2qzvwyKBsm0u-9r89J0WLKOvUML-7wYqSkd2eu3Q-pt1PsIDDeDuKcHPNITCTfODy6EMC4cVFNWQuxDPUQYbAeGg=s0",
            backgroundColor: nil,
            name: "CryptoPunk #7842",
            externalLink: nil,
            permalink: "https://opensea.io/assets/0x495f947276749ce646f68ac8c248420045cb7b5e/56053100554430904991517213092900507939703437358200320741647226733043910705153",
            assetContract: nil,
            description: "Welcome to the home of Desperate ApeWife on OpenSea. About 333 Desperate ApeWife CLUB laser eyes NFTs on the Ethereum blockchain. 🤩🤩\n\nDiscover the best items in this collection, Desperate ApeWife is a collection of female laser eyes. Come browsing and purchase your most favorite items at our store 😍💯\n\n🤎We love and value female very much. We do not hesitate to send various gifts to owners of more than one item.💟💟",
            traits: [.init(traitType: "Upper body", value: "Gangster", displayType: nil, maxValue: nil, traitCount: nil, order: nil), .init(traitType: "Skin Color", value: "Tycon", displayType: nil, maxValue: nil, traitCount: nil, order: nil), .init(traitType: "Hand", value: "Jules", displayType: nil, maxValue: nil, traitCount: 538, order: nil)])
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
