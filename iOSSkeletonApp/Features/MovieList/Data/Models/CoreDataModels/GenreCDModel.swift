//
//  GenreCDModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import CoreData

extension GenreCDModel: DomainConvertible {
    
    convenience init(id: Int32, name: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "GenreCDModel", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.id = id
        self.name = name
    }
    
    func toDomain() -> Genre {
        return Genre(id: Int(id), name: name ?? "")
    }
}
