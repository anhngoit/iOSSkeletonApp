//
//  MovieResponseDTO.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

// MARK: - Data Transfer Object
struct MovieResponseDTO: Decodable {
    let page: Int
    let totalPages: Int
    let movies: [MovieDTO]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
}

// MARK: - Mappings to Domain
extension MovieResponseDTO {
    func toDomain() -> MovieResponse {
        return .init(page: page,
                     totalPages: totalPages,
                     movies: movies.map { $0.toDomain() })
    }
}
