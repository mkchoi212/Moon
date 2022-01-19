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
