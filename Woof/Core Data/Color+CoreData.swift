//
//  Color+CoreData.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import SwiftUI

extension Color {
    static func deserialized(from data: Data?) -> Color? {
        guard let data = data else {
            return nil
        }

        guard let color = try? NSKeyedUnarchiver.unarchivedObject(ofClass: UIColor.self, from: data) else {
            return nil
        }
        
        return Color(color)
    }
    
    var data: Data? {
        let uiColor = UIColor(self)
        return try? NSKeyedArchiver.archivedData(withRootObject: uiColor, requiringSecureCoding: false)
    }
}
