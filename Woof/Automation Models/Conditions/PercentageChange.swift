//
//  PercentageChange.swift
//  Woof
//
//  Created by Mike Choi on 12/6/21.
//

import SwiftUI
import CoreData

final class PercentChange: CardRepresentable, Condition {
    
    let type = ConditionType.percentChange
    
    let id: UUID
    var cryptoSymbol: CryptoTypeProperty
    var comparator: ComparatorProperty
    var percentage: PercentageProperty
    
    var properties: [CardProperty] {
        [ cryptoSymbol, comparator, percentage ]
    }
    
    init(id: UUID, cryptoSymbol: String?, comparator: Comparator?, percentage: Double?) {
        self.id = id
        self.cryptoSymbol = CryptoTypeProperty(cryptoSymbol: cryptoSymbol)
        self.comparator = ComparatorProperty(value: comparator)
        self.percentage = PercentageProperty(percentage: percentage)
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        let entity = PercentChangeEntity(context: context)
        entity.type = type.rawValue
        entity.id = id
        entity.cryptoSymbol = cryptoSymbol.cryptoSymbol
        entity.comparator = comparator.value?.rawValue
        entity.percentage = percentage.percentage ?? .nan
        return entity
    }
}

extension PercentChange: ComparatorSettable {
    func set(comparator: Comparator, for propertyId: UUID) {
        self.comparator.value = comparator
    }
}

// MARK: - CoreData

extension PercentChange {
    convenience init?(entity: PercentChangeEntity?) {
        guard let entity = entity, let id = entity.id else {
            return nil
        }
        
        self.init(id: id,
                  cryptoSymbol: entity.cryptoSymbol,
                  comparator: Comparator(rawValue: entity.comparator),
                  percentage: entity.percentage)
    }
}


extension PercentChange: Equatable {
    static func ==(lft: PercentChange, rht: PercentChange) -> Bool {
        lft.cryptoSymbol.cryptoSymbol == rht.cryptoSymbol.cryptoSymbol &&
        lft.comparator.value == rht.comparator.value &&
        lft.percentage.percentage == rht.percentage.percentage
    }
}
