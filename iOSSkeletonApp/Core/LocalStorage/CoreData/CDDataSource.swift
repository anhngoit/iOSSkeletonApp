//
//  CoreDataSource.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 08/09/2024.
//
import CoreData
import Combine

class CDDataSource<T: NSManagedObject>: LocalStorage {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    // Create or Update a single object.
    func createOrUpdate(item: T) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.perform {
                do {
                    // For update: ensure item is attached to context & has changes.
                    if item.managedObjectContext != self.context {
                        self.context.insert(item)
                    }
                    if self.context.hasChanges {
                        try self.context.save()
                    }
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    // Create or Update multiple objects.
    func createOrUpdate(items: [T]) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.perform {
                do {
                    for item in items where item.managedObjectContext != self.context {
                        self.context.insert(item)
                    }
                    if self.context.hasChanges {
                        try self.context.save()
                    }
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    // Read by objectID
    func read<K: Hashable>(byId id: K) -> AnyPublisher<T?, Error> {
        Future { promise in
            self.context.perform {
                guard let objectID = id as? NSManagedObjectID else {
                    promise(.failure(NSError(domain: "Invalid ID", code: 1)))
                    return
                }
                do {
                    let object = try self.context.existingObject(with: objectID) as? T
                    promise(.success(object))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    // Fetch all objects
    func readAll() -> AnyPublisher<[T], Error> {
        Future { promise in
            self.context.perform {
                let request = NSFetchRequest<T>(entityName: String(describing: T.self))
                do {
                    let results = try self.context.fetch(request)
                    promise(.success(results))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    // Delete a single object
    func delete(item: T) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.perform {
                self.context.delete(item)
                do {
                    try self.context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    // Delete multiple objects
    func delete(items: [T]) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.perform {
                for item in items {
                    self.context.delete(item)
                }
                do {
                    try self.context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    // Batch delete all objects of type T
    func deleteAll() -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.perform {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try self.context.execute(deleteRequest)
                    try self.context.save() // Save after batch delete for consistency
                    self.context.reset()    // Reset context to avoid invalid in-memory references
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }

    // Fetch with predicate
    func filter(with predicate: NSPredicate) -> AnyPublisher<[T], Error> {
        Future { promise in
            self.context.perform {
                let fetchRequest = NSFetchRequest<T>(entityName: String(describing: T.self))
                fetchRequest.predicate = predicate
                do {
                    let result = try self.context.fetch(fetchRequest)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
}
