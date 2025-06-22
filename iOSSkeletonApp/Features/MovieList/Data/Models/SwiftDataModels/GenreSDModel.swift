//
//  GenreSDModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftData
import Foundation

@Model
class GenreSDModel {
    @Attribute(.unique) var id: Int
    var name: String
    var movie: MovieSDModel?

    init(id: Int, name: String, movie: MovieSDModel?) {
        self.id = id
        self.name = name
        self.movie = movie
    }
}

extension GenreSDModel: DomainConvertible {
    func toDomain() -> Genre {
        return Genre(id: id, name: name)
    }
}
