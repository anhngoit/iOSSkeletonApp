//
//  LocalDataService.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 08/09/2024.
//

import Foundation

protocol LocalStorage {
    associatedtype T
        
    func createOrUpdate(item: T) async throws
    func createOrUpdate(items: [T]) async throws
    func read<K>(byId id: K) async throws -> T?
    func readAll() async throws -> [T]
    func filter(predicate: NSPredicate) async throws -> [T]
    func delete(item: T) async throws
    func delete(items: [T]) async throws
    func deleteAll() async throws
    func delete(filter predicate: NSPredicate) async throws
}

enum DatabaseType {
    case realm
    case coreData
//    case swiftData
//    case firestore
}
