//
//  PersistanceController.swift
//  Woof
//
//  Created by Mike Choi on 12/15/21.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
   
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
    }
}
