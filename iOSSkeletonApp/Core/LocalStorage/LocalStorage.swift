//
//  LocalStorage.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Combine
import SwiftData

protocol LocalStorage {
    associatedtype Model

    func createOrUpdate(item: Model) -> AnyPublisher<Void, Error>
    func createOrUpdate(items: [Model]) -> AnyPublisher<Void, Error>
    func read<K: Hashable>(byId id: K) -> AnyPublisher<Model?, Error>
    func readAll() -> AnyPublisher<[Model], Error>
    func filter(with predicate: NSPredicate) -> AnyPublisher<[Model], Error>
    func delete(item: Model) -> AnyPublisher<Void, Error>
    func delete(items: [Model]) -> AnyPublisher<Void, Error>
    func deleteAll() -> AnyPublisher<Void, Error>
}

//// Default implementations for optional methods
extension LocalStorage {
    func filter(predicate: NSPredicate) -> AnyPublisher<[Model], Error> {
        // Default behavior or empty implementation
        Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func filter(with predicate: Predicate<Model>) -> AnyPublisher<[Model], Error> {
        // Default behavior or empty implementation
        Just([])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
