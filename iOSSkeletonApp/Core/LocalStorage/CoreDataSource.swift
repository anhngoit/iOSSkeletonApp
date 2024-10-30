//
//  CoreDataSource.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 08/09/2024.
//
import CoreData
import Foundation

class CoreDataSource<T: NSManagedObject>: LocalStorage {
    private let context: NSManagedObjectContext

    init() {
        self.context = CoreDataStack.shared.context
    }

    // Initializer with custom context (optional)
    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func createOrUpdate(item: T) throws {
        try context.save()
    }

    func createOrUpdate(items: [T]) throws {
        try context.save()
    }

    func read<K>(byId id: K) throws -> T? {
        guard let id = id as? NSManagedObjectID else {
            throw NSError(domain: "CoreDataSource", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid ID type"])
        }
        return try context.existingObject(with: id) as? T
    }

    func readAll() throws -> [T] {
        let fetchRequest = T.fetchRequest()
        guard let result = try context.fetch(fetchRequest) as? [T] else {
            return []
        }
        return result
    }

    func filter(predicate: NSPredicate) throws -> [T] {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        guard let result = try context.fetch(fetchRequest) as? [T] else {
            return []
        }
        return result
    }

    func delete(item: T) throws {
        context.delete(item)
        try context.save()
    }

    func delete(items: [T]) throws {
        for item in items {
            context.delete(item)
        }
        try context.save()
    }

    func deleteAll() throws {
        let fetchRequest = T.fetchRequest()
        fetchRequest.includesPropertyValues = false
        let objects = try context.fetch(fetchRequest) as? [T] ?? []
        for object in objects {
            context.delete(object)
        }
        try context.save()
    }

    func delete(filter predicate: NSPredicate) throws {
        let fetchRequest = T.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.includesPropertyValues = false
        let objects = try context.fetch(fetchRequest) as? [T] ?? []
        for object in objects {
            context.delete(object)
        }
        try context.save()
    }
}
