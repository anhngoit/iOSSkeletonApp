//
//  MovieResponse.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/06/2024.
//

import Foundation

// MARK: - Entity
struct MoviePage: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}

// MARK: - Mappings to DTO
extension MoviePage {
    func toDTO() -> MovieResponse {
        return .init(page: page,
                     totalPages: totalPages,
                     results: movies.map { $0.toDTO() })
    }
    
    func toSDModel() -> MoviePageSDModel {
        return .init(page: page,
                     totalPages: totalPages,
                     movies: movies.map {$0.toSDModel()})
    }
    
    func toCDModel() -> MoviePageCDModel {
        var movieList = [MovieCDModel]()
        movieList = movies.map {$0.toCDModel()}
        return .init(page: Int32(page),
                     totalPages: Int32(totalPages),
                     movies: NSSet(array: movieList), context: CoreDataStack.shared.context)
    }
}
