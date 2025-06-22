//
//  MovieSDModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftData
import Foundation

@Model
class MovieSDModel {
    @Attribute(.unique) var id: Int
    var title: String?
    @Relationship(deleteRule: .nullify, inverse: \GenreSDModel.movie) var genres: [GenreSDModel]
    var posterPath: String?
    var backdropPath: String?
    var overview: String?
    var releaseDate: Date?
    var moviePage: MoviePageSDModel?

    init(id: Int, title: String?, genres: [GenreSDModel] = [], posterPath: String?, backdropPath: String?, overview: String?, releaseDate: Date?, movieResponse: MoviePageSDModel?) {
        self.id = id
        self.title = title
        self.genres = genres
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.moviePage = movieResponse
    }
}

extension MovieSDModel: DomainConvertible {
    func toDomain() -> Movie {
        return Movie(
            id: String(id),
            title: title,
            genres: genres.map { $0.toDomain() },
            posterPath: posterPath,
            backdropPath: backdropPath,
            overview: overview,
            releaseDate: releaseDate
        )
    }
}
