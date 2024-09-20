//
//  Movie.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation
import RealmSwift

// MARK: - Entity
struct Movie: Equatable, Identifiable {
    let id: String
    let title: String?
    let genres: [Genre]
    let posterPath: String?
    let backdropPath: String?
    let overview: String?
    let releaseDate: Date?
}


struct Genre: Equatable, Identifiable {
    let id: Int
    let name: String
    
    func toDTO() -> GenreDTO {
        return GenreDTO(id: id, name: name)
    }
    
    func toRealmModel() -> GenreRModel {
        return GenreRModel(id: id, name: name)
    }
}


// MARK: - Mappings to DTO
extension Movie {
    func toDTO() -> MovieDTO {
        return .init(id: Int(id) ?? 0,
                     title: title,
                     genres: genres.map{ $0.toDTO() } ,
                     posterPath: posterPath,
                     backdropPath: backdropPath,
                     overview: overview,
                     releaseDate: releaseDate?.toString(withCustomDateFormat: "yyyy-MM-dd"))
    }
}

// MARK: - Mappings to Real Model
extension Movie {
    func toRealmModel() -> MovieRModel {
        let genreList = List<GenreRModel>()
        genreList.append(objectsIn: genres.map{ $0.toRealmModel() })
        return .init(id: Int(id) ?? 0,
                     title: title,
                     genres: genreList,
                     posterPath: posterPath,
                     backdropPath: backdropPath,
                     overview: overview,
                     releaseDate: releaseDate)
    }
}

// MARK: - stub
extension Movie {
    init(id: String) {
        self.id = id
        self.title = nil
        self.genres = []
        self.posterPath = nil
        self.backdropPath = nil
        self.overview = nil
        self.releaseDate = nil
    }
    
    static func stub(id: String = "365177",
                title: String = "Borderlands" ,
                genre: [Genre] = [Genre](),
                posterPath: String? = "/865DntZzOdX6rLMd405R0nFkLmL.jpg",
                backdropPath: String? = "/mKOBdgaEFguADkJhfFslY7TYxIh.jpg",
                overview: String = "Returning to her home planet, an infamous bounty hunter forms an unexpected alliance with a team of unlikely heroes. Together, they battle monsters and dangerous bandits to protect a young girl who holds the key to unimaginable power.",
                releaseDate: Date? = Date.stringToDate(string: "2024-08-07")) -> Self {
        Movie(id: id,
              title: title,
              genres: genre,
              posterPath: posterPath, 
              backdropPath: backdropPath,
              overview: overview,
              releaseDate: releaseDate)
    }
}
