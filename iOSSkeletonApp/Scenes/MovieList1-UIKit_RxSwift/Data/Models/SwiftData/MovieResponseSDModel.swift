//
//  MovieResponseSDModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 31/10/2024.
//

import SwiftData

@Model
class MovieResponseSDModel {
    @Attribute(.unique) var page: Int
    var totalPages: Int
    @Relationship(deleteRule: .cascade, inverse: \MovieSDModel.movieResponse) var movies: [MovieSDModel]

    init(page: Int, totalPages: Int, movies: [MovieSDModel] = []) {
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }

    func toDomain() -> MovieResponse {
        return MovieResponse(
            page: page,
            totalPages: totalPages,
            movies: movies.map { $0.toDomain() }
        )
    }
}
