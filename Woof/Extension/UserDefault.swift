//
//  UserDefault.swift
//  Woof
//
//  Created by Mike Choi on 12/21/21.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    let defaults: UserDefaults
    
    init(_ key: String, defaultValue: T, suiteName: String? = nil) {
        self.key = key
        self.defaultValue = defaultValue
        
        if let customSuite = suiteName {
            self.defaults = UserDefaults(suiteName: customSuite)!
        } else {
            self.defaults = UserDefaults.standard
        }
    }
    
    var wrappedValue: T {
        get {
            return defaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            defaults.set(newValue, forKey: key)
        }
    }
}
