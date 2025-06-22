//
//  GenreDTO.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

struct GenreDTO: Codable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

extension GenreDTO: DomainConvertible {
    func toDomain() -> Genre {
        return Genre(id: id, name: name)
    }
}
