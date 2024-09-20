//
//  MovieResponse.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/06/2024.
//

import Foundation
import RealmSwift

// MARK: - Entity
struct MovieResponse: Equatable {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}

// MARK: - Mappings to DTO
extension MovieResponse {
    func toDTO() -> MovieResponseDTO {
        return .init(page: page,
                     totalPages: totalPages,
                     movies: movies.map { $0.toDTO() })
    }
    
    func toReamModel() -> MovieResponseRModel {
        let movieList = List<MovieRModel>()
        movieList.append(objectsIn: movies.map {$0.toRealmModel()} )
        return .init(page: page,
                     totalPages: totalPages,
                     movies: movieList)
    }
}
