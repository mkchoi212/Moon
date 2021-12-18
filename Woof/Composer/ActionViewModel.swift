//
//  ActionViewModel.swift
//  Woof
//
//  Created by Mike Choi on 12/18/21.
//

import SwiftUI
import OrderedCollections

final class ActionViewModel: ObservableObject {
    private var action: CardRepresentable
    var entityMap: OrderedDictionary<String, TextEntity> = [:] {
        didSet {
            attributedString = description()
        }
    }
    
    @Published var attributedString = AttributedString()
    
    init(action: CardRepresentable) {
        self.action = action
        self.entityMap = OrderedDictionary(uniqueKeysWithValues: action.entities.map { entity in
            (entity.id.uuidString, entity)
        })
        self.attributedString = self.description()
    }
    
    func set(entity: TextEntity, for uuid: UUID) {
        entityMap[uuid.uuidString] = entity
    }
    
    func description() -> AttributedString {
        var res = AttributedString()
        
        entityMap.values.enumerated().forEach { (i, entity) in
            let uuid = entity.id.uuidString
            
            if let action = entity.action {
                var sub: AttributedString
                
                if let filledText = entity.text {
                    sub = AttributedString(filledText)
                    sub.foregroundColor = .blue
                    sub.backgroundColor = .lightBlue
                    sub.font = .system(size: 18, weight: .semibold, design: .rounded)
                } else {
                    var placeholder = action.placeholder
                    if i > 0 {
                        placeholder = placeholder.lowercased()
                    }
                    sub = AttributedString(placeholder)
                    sub.foregroundColor = .gray
                    sub.backgroundColor = .lightBlue
                    sub.font = .system(size: 18, weight: .medium, design: .rounded)
                }
                
                sub.link = URL(string: "woof://\(uuid)")!
                res += sub
            } else {
                var sub = AttributedString(entity.text ?? "")
                sub.font = .system(size: 18)
                res += sub
            }
            
            if i < entityMap.count - 1 {
                res += AttributedString(" ")
            }
        }
        
        return res
    }
    
    func resolve(deeplink: URL) -> TextEntity? {
        if let id = deeplink.host {
            return entityMap[id]
        } else {
            return nil
        }
    }
}
