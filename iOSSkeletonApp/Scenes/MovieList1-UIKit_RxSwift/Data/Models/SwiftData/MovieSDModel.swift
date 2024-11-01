//
//  MovieSDModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 31/10/2024.
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
    var movieResponse:MovieResponseSDModel?

    init(id: Int, title: String?, genres: [GenreSDModel] = [], posterPath: String?, backdropPath: String?, overview: String?, releaseDate: Date?, movieResponse: MovieResponseSDModel?) {
        self.id = id
        self.title = title
        self.genres = genres
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
        self.movieResponse = movieResponse
    }
    
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

    func toDomain() -> Genre {
        return Genre(id: id, name: name)
    }
}

