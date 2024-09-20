//
//  SDMovieResponse.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 08/09/2024.
//

import Foundation
import RealmSwift

final class MovieResponseRModel: Object, Identifiable {
    @Persisted(primaryKey: true) var page: Int = 0
    @Persisted var totalPages: Int = 0
    @Persisted var movies: List<MovieRModel> = List<MovieRModel>()
    
    convenience init(page: Int, totalPages: Int, movies: List<MovieRModel>) {
        self.init()
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }
}

extension MovieResponseRModel {
    func toDomain() -> MovieResponse {
        return .init(page: page,
                     totalPages: totalPages,
                     movies: movies.map { $0.toDomain() })
    }
}
