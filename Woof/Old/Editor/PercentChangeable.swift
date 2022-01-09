//
//  PercentChangeable.swift
//  Woof
//
//  Created by Mike Choi on 12/18/21.
//

import Foundation

protocol PercentSettable {
    func set(percent: Double, for propertyId: UUID)
}

protocol ComparatorSettable {
    func set(comparator: Comparator, for propertyId: UUID)
}

protocol CoinSettable {
    func set(symbol: String, for propertyId: UUID)
}
