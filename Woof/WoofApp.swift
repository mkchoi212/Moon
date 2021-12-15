//
//  WoofApp.swift
//  Woof
//
//  Created by Mike Choi on 12/5/21.
//

import SwiftUI

@main
struct WoofApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            WoofTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
