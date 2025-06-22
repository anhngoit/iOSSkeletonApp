//
//  SDDataSource.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import SwiftData
import Combine

// Generic class for local data storage using SwiftData
class SDDataSource<T>: LocalStorage where T: PersistentModel & Identifiable {
    
    private let modelContext: ModelContext
    
    // Initialize with ModelContainer
    init() {
        do {
            let container = try ModelContainer(for: T.self)
            self.modelContext = ModelContext(container)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error.localizedDescription)")
        }
    }

    /// Create or update a single item in the database
    func createOrUpdate(item: T) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                self.modelContext.insert(item)
                try self.saveContext()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Create or update multiple items in the database
    func createOrUpdate(items: [T]) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                items.forEach { self.modelContext.insert($0) }
                try self.saveContext()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Read an item by its ID
    func read<K>(byId id: K) -> AnyPublisher<T?, Error> {
        Future { promise in
            do {
                guard let id = id as? PersistentIdentifier else {
                    throw NSError(domain: "LocalDataSource", code: 1, userInfo: [NSLocalizedDescriptionKey: "Invalid ID type"])
                }
                let result = self.modelContext.model(for: id) as? T
                promise(.success(result))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Read all items from the database
    func readAll() -> AnyPublisher<[T], Error> {
        Future { promise in
            do {
                let fetchDescriptor = FetchDescriptor<T>()
                let result = try self.modelContext.fetch(fetchDescriptor)
                promise(.success(result))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Filter items using a predicate
    func filter(with predicate: Predicate<T>) -> AnyPublisher<[T], Error> {
        Future { promise in
            do {
                let fetchDescriptor = FetchDescriptor<T>(predicate: predicate)
                let result = try self.modelContext.fetch(fetchDescriptor)
                promise(.success(result))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Delete a single item from the database
    func delete(item: T) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                self.modelContext.delete(item)
                try self.saveContext()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Delete multiple items from the database
    func delete(items: [T]) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                items.forEach { self.modelContext.delete($0) }
                try self.saveContext()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    /// Delete all items from the database
    func deleteAll() -> AnyPublisher<Void, Error> {
        readAll()
            .flatMap { items in
                Future { promise in
                    do {
                        items.forEach { self.modelContext.delete($0) }
                        try self.saveContext()
                        promise(.success(()))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
            .eraseToAnyPublisher()
    }

    /// Save changes to the database
    private func saveContext() throws {
        do {
            try modelContext.save()
        } catch {
            throw NSError(domain: "LocalDataSource", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to save context: \(error.localizedDescription)"])
        }
    }
    
    func filter(with predicate: NSPredicate) -> AnyPublisher<[T], any Error> {
        Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
