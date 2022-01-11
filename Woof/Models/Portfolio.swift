//
//  Portfolio.swift
//  Woof
//
//  Created by Mike Choi on 1/11/22.
//

import Foundation

final class Portfolio: Codable, ObservableObject {
    let totalValue: Double
    let stakedValue: Double
    let assetsValue: Double
    let depositedValue: Double
    let borrowedValue: Double
    let absoluteChange24h: Double
    let relativeChange24h: Double?
}
