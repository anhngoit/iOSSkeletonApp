//
//  SDMovie.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 08/09/2024.
//

import Foundation
import RealmSwift

class MovieRModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String? = nil
    @Persisted var genres: List<GenreRModel> = List<GenreRModel>()
    @Persisted var posterPath: String? = nil
    @Persisted var backdropPath: String? = nil
    @Persisted var overview: String? = nil
    @Persisted var releaseDate: Date? = nil
    
    convenience init(id: Int, title: String?, genres: List<GenreRModel>, posterPath: String?, backdropPath: String?, overview: String?, releaseDate: Date?) {
        self.init()
        self.id = id
        self.title = title
        self.genres = genres
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate
    }
    
    func toDomain() -> Movie {
        var genresDomain = [Genre]()
        genresDomain = genres.map { $0.toDomain() }
        return .init(id: String(id),
                     title: title,
                     genres:  genresDomain,
                     posterPath: posterPath,
                     backdropPath: backdropPath,
                     overview: overview,
                     releaseDate: releaseDate)
    }
}

class GenreRModel: Object, Identifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    
    convenience init(id: Int, name: String) {
        self.init()
        self.id = id
        self.name = name
    }
    
    func toDomain() -> Genre {
        return Genre(id: id, name: name)
    }
}
