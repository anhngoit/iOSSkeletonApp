//
//  MovieResponse.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

// MARK: - Data Transfer Object
typealias MovieResponse = APIResponse<MovieDTO>

// MARK: - Mappings to Domain
extension MovieResponse: DomainConvertible {
    func toDomain() -> MoviePage {
        return .init(page: page,
                     totalPages: totalPages,
                     movies: results.map { $0.toDomain() })
    }
}
