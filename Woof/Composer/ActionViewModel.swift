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
    var propMap: OrderedDictionary<String, CardProperty> = [:] {
        didSet {
            attributedString = description()
        }
    }
    
    @Published var attributedString = AttributedString()
    
    init(action: CardRepresentable) {
        self.action = action
        self.propMap = OrderedDictionary(uniqueKeysWithValues: action.properties.map { prop in
            (prop.id.uuidString, prop)
        })
        self.attributedString = self.description()
    }
    
    func set(property: CardProperty, for uuid: UUID) {
        propMap[uuid.uuidString] = property
    }
    
    func description() -> AttributedString {
        var res = AttributedString()
        
        propMap.values.enumerated().forEach { (i, prop) in
            let uuid = prop.id.uuidString
            let action = prop.action
            
            if action == .staticText {
                var sub = AttributedString(prop.description ?? "")
                sub.font = .system(size: 18)
                res += sub
            } else {
                var sub: AttributedString
                
                if let filledText = prop.description {
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
            }
            
            if i < propMap.count - 1 {
                res += AttributedString(" ")
            }
        }
        
        return res
    }
    
    func resolve(deeplink: URL) -> CardProperty? {
        if let id = deeplink.host {
            return propMap[id]
        } else {
            return nil
        }
    }
}
