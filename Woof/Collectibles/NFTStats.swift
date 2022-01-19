//
//  NFTStats.swift
//  Woof
//
//  Created by Mike Choi on 1/17/22.
//

import Foundation

struct NFTStats: Codable, Hashable {
    let oneDayVolume: Double
    let oneDayChange: Double
    let oneDaySales: Double
    let oneDayAveragePrice: Double
    let totalSupply: Int
    let totalSales: Double
    let totalVolume: Double
    let count: Int
    let floorPrice: Double
    let marketCap: Double
    let numOwners: Int
}
