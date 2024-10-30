//
//  MovieCDModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 29/10/2024.
//

import CoreData

extension MovieCDModel {
    
    convenience init(id: Int32, title: String?, genres: NSSet?, posterPath: String?, backdropPath: String?, overview: String?, releaseDate: Date?, context: NSManagedObjectContext) {
        // Use the designated initializer
        let entity = NSEntityDescription.entity(forEntityName: "MovieCDModel", in: context)!
        self.init(entity: entity, insertInto: context)
        
        // Set properties
        self.id = id
        self.title = title
        self.genres = genres
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        self.overview = overview
        self.releaseDate = releaseDate?.toString()
    }
    
    func toDomain() -> Movie {
        var genresDomain = [Genre]()
    
        if let genresDTO = genres?.allObjects as? [GenreCDModel] {
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

extension GenreCDModel {
    
    convenience init(id: Int32, name: String, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "GenreCDModel", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.id = id
        self.name = name
    }
    
    func toDomain() -> Genre {
        return Genre(id: Int(id), name: name ?? "")
    }
}
