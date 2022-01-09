//
//  ActionViewModel.swift
//  Woof
//
//  Created by Mike Choi on 12/18/21.
//

import SwiftUI
import OrderedCollections

final class ActionViewModel: ObservableObject {
    var action: CardRepresentable
    
    @Published var attributedString = AttributedString()
    
    init(action: CardRepresentable) {
        self.action = action
        self.attributedString = self.description()
    }
    
    func generateDescription() {
        attributedString = description()
    }
    
    func description() -> AttributedString {
        var res = AttributedString()
        let properties = action.properties
        
        properties.enumerated().forEach { (i, prop) in
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
            
            if i < properties.count - 1 {
                res += AttributedString(" ")
            }
        }
        
        return res
    }
    
    func resolve(deeplink: URL) -> CardProperty? {
        if let id = deeplink.host {
            return action.properties.first { $0.id.uuidString == id }
        } else {
            return nil
        }
    }
}
