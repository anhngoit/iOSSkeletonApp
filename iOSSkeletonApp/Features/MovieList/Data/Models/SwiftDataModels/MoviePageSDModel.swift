//
//  MoviePageSDModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftData

@Model
class MoviePageSDModel {
    @Attribute(.unique) var page: Int
    var totalPages: Int
    @Relationship(deleteRule: .cascade, inverse: \MovieSDModel.moviePage) var movies: [MovieSDModel]

    init(page: Int, totalPages: Int, movies: [MovieSDModel] = []) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }
}

extension MoviePageSDModel: DomainConvertible {
    func toDomain() -> MoviePage {
        return MoviePage(
            page: page,
            totalPages: totalPages,
            movies: movies.map { $0.toDomain() }
        )
    }
}
