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
    var percentage: PercentageProperty
    
    var properties: [CardProperty] {
        [ cryptoSymbol, StaticText(text: "changes by"), percentage ]
    }
    
    init(id: UUID, cryptoSymbol: String?, percentage: Double?) {
        self.id = id
        self.cryptoSymbol = CryptoTypeProperty(cryptoSymbol: cryptoSymbol)
        self.percentage = PercentageProperty(value: percentage)
    }
    
    func coreDataModel(with context: NSManagedObjectContext) -> ConditionEntity {
        let entity = PercentChangeEntity(context: context)
        entity.type = type.rawValue
        entity.id = id
        entity.cryptoSymbol = cryptoSymbol.cryptoSymbol
        entity.percentage = percentage.value ?? .nan
        return entity
    }
}

extension PercentChange: PercentSettable {
    func set(percent: Double, for propertyId: UUID) {
        self.percentage.value = percent
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
                  percentage: entity.percentage)
    }
}


extension PercentChange: Equatable {
    static func ==(lft: PercentChange, rht: PercentChange) -> Bool {
        lft.cryptoSymbol.cryptoSymbol == rht.cryptoSymbol.cryptoSymbol &&
        lft.percentage.value == rht.percentage.value
    }
}
