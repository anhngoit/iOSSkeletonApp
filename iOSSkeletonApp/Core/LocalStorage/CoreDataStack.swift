//
//  CoreDataStack.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 30/10/2024.
//

import CoreData
import Foundation

class CoreDataStack {
    static let shared = CoreDataStack()
    
    let persistentContainer: NSPersistentContainer
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "Model") // Replace with your actual data model name
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
}

