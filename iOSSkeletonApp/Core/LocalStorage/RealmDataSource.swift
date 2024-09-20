//
//  RealmDataService.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 08/09/2024.
//

import RealmSwift
import Foundation

class RealmDataSource<T: Object>: LocalStorage {
    
    init() {
        // Optionally, you can log the Realm file path here if needed
        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
            print("Realm file path: \(realmURL)")
        }
    }

    private func getRealm() throws -> Realm {
        return try Realm()
    }

    func createOrUpdate(item: T) throws {
        let realm = try getRealm()
        try realm.write {
            realm.add(item, update: .modified)
        }
    }

    func createOrUpdate(items: [T]) throws {
        let realm = try getRealm()
        try realm.write {
            realm.add(items, update: .modified)
        }
    }

    func read<K>(byId id: K) throws -> T? {
        let realm = try getRealm()
        return realm.object(ofType: T.self, forPrimaryKey: id)
    }

    func readAll() throws -> [T] {
        let realm = try getRealm()
        return Array(realm.objects(T.self))
    }

    func filter(predicate: NSPredicate) throws -> [T] {
        let realm = try getRealm()
        return Array(realm.objects(T.self).filter(predicate))
    }

    func delete(item: T) throws {
        let realm = try getRealm()
        try realm.write {
            realm.delete(item)
        }
    }

    func delete(items: [T]) throws {
        let realm = try getRealm()
        try realm.write {
            realm.delete(items)
        }
    }

    func deleteAll() throws {
        let realm = try getRealm()
        try realm.write {
            realm.delete(realm.objects(T.self))
        }
    }

    func delete(filter predicate: NSPredicate) throws {
        let realm = try getRealm()
        let items = realm.objects(T.self).filter(predicate)
        try realm.write {
            realm.delete(items)
        }
    }
}
