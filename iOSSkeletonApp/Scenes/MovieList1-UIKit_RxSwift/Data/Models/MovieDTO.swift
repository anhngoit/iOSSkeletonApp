//
//  MovieDTO.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

struct MovieDTO: Decodable {
    let id: Int
    let title: String?
    let genres: [GenreDTO]?
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case genres
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case overview
        case releaseDate = "release_date"
    }
    
    func toDomain() -> Movie {
        var genresDomain = [Genre]()
        if let genresDTO = genres {
            genresDomain = genresDTO.map { $0.toDomain() }
        }
        return .init(id: String(id),
                     title: title,
                     genres:  genresDomain,
                     posterPath: posterPath,
                     backdropPath: backdropPath,
                     overview: overview,
                     releaseDate: Date.stringToDate(string: releaseDate ?? "", withCustomDateFormat: "yyyy-MM-dd"))
    }
}

struct GenreDTO: Decodable {
    let id: Int
    let name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    func toDomain() -> Genre {
        return Genre(id: id, name: name)
    }
}


