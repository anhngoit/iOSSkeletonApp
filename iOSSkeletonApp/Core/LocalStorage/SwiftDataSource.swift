//
//  SwiftDataSource.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 31/10/2024.
//

import SwiftData
import Foundation

class SwiftDataSource<T>: LocalStorage where T: PersistentModel & Identifiable {
    private let modelContext: ModelContext

    // Initialize with ModelContainer, handle errors if container fails to initialize
    init() {
        do {
            let container = try ModelContainer(for: T.self)
            self.modelContext = ModelContext(container)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }

    func createOrUpdate(item: T) async throws {
        modelContext.insert(item)
        try modelContext.save()
    }

    func createOrUpdate(items: [T]) async throws {
        for item in items {
            modelContext.insert(item)
        }
        try modelContext.save()
    }

    func read<K>(byId id: K) async throws -> T? {
        guard let id = id as? PersistentIdentifier else {
            throw NSError(domain: "SwiftDataSource", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid ID type"])
        }
        return modelContext.model(for: id) as? T
    }

    func readAll() async throws -> [T] {
        let fetchDescriptor = FetchDescriptor<T>()
        return try modelContext.fetch(fetchDescriptor)
    }
    
    func filter(with predicate: Predicate<T>) async throws -> [T] {
        let fetchDescriptor = FetchDescriptor<T>(predicate: predicate)
        return try modelContext.fetch(fetchDescriptor)
    }

    func delete(item: T) async throws {
        modelContext.delete(item)
        try modelContext.save()
    }

    func delete(items: [T]) async throws {
        for item in items {
            modelContext.delete(item)
        }
        try modelContext.save()
    }

    func deleteAll() async throws {
        let items = try await readAll()
        for item in items {
            modelContext.delete(item)
        }
        try modelContext.save()
    }

    func delete(filter predicate: NSPredicate) async throws {
        let items = try await filter(predicate: predicate)
        for item in items {
            modelContext.delete(item)
        }
        try modelContext.save()
    }
}
