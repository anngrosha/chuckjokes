//
//  PersistentContainer.swift
//  chuckjokes
//
//  Created by Ренат Хайруллин on 15.07.2023.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    
    static let shared: PersistentContainer = {
        let container = PersistentContainer(name: "chuckjokes")
        container.loadPersistentStores { _, error in
            if let error {
                print(error)
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
