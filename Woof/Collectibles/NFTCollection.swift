//
//  NFTCollection.swift.swift
//  Woof
//
//  Created by Mike Choi on 1/17/22.
//

import Foundation

enum SafelistStatus: String, Codable, Hashable {
    // brand new collections
    case notRequested = "not_requested"
    
    // collections that requested safelisting
    case requested
    
    // collections that are approved on OpenSea and can be found in search results
    case approved
    
    // verified collections
    case verified
}

struct NFTCollection: Codable, Hashable, Identifiable {
    let name: String
    let description: String?
    let createdDate: String
    
    // Used to link to the collection on OpenSea.
    // This value can change by the owner but must be unique across all collection slugs in OpenSea
    let slug: String?
    
    let imageUrl: String?
    let largeImageUrl: String?
    let bannerImageUrl: String?
    let safelistRequestStatus: SafelistStatus
    let payoutAddress: String?
    let stats: NFTStats

    let chatUrl: String?
    let discordUrl: String?
    let featuredImageUrl: String?
    let mediumUserName: String?
    let telegramUrl: String?
    let twitterUsername: String?
    let instagramUsername: String?
    let wikiUrl: String?
    let ownedAssetCount: Int
    
    var id: String {
        name
    }
    
    static let dummy = NFTCollection(name: "CryptoPunks", description: "CryptoPunks launched as a fixed set of 10,000 items in mid-2017 and became one of the inspirations for the ERC-721 standard. They have been featured in places like The New York Times, Christie’s of London, Art|Basel Miami, and The PBS NewsHour.", createdDate: "123", slug: "CryptoPunks", imageUrl: "https://lh3.googleusercontent.com/jAnoAAC4aNNREN2qzvwyKBsm0u-9r89J0WLKOvUML-7wYqSkd2eu3Q-pt1PsIDDeDuKcHPNITCTfODy6EMC4cVFNWQuxDPUQYbAeGg=s0", largeImageUrl: nil, bannerImageUrl: nil, safelistRequestStatus: .approved, payoutAddress: nil, stats: NFTStats(oneDayVolume: 0, oneDayChange: 0, oneDaySales: 0, oneDayAveragePrice: 0, totalSupply: 0, totalSales: 0, totalVolume: 0, count: 0, floorPrice: 0, marketCap: 0, numOwners: 0), chatUrl: nil, discordUrl: nil, featuredImageUrl: nil, mediumUserName: nil, telegramUrl: nil, twitterUsername: nil, instagramUsername: nil, wikiUrl: nil, ownedAssetCount: 4)
}

extension NFTCollection: Comparable {
    static func < (lhs: NFTCollection, rhs: NFTCollection) -> Bool {
        lhs.name.compare(rhs.name) == .orderedDescending
    }
}

struct NFTContract: Codable, Hashable {
    let address: String
    let name: String
    let symbol: String?
    let imageUrl: String?
    let description: String?
    let externalLink: String?
}
