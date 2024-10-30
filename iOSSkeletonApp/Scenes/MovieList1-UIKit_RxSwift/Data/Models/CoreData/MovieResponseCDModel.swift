//
//  MovieResponseCDModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 29/10/2024.
//

import Foundation
import CoreData

extension MovieResponseCDModel {
    
    convenience init(page: Int32, totalPages: Int32, movies: NSSet, context: NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "MovieResponseCDModel", in: context)!
        self.init(entity: entity, insertInto: context)
        
        self.page = page
        self.totalPages = totalPages
        self.movies = movies
    }
    
    func toDomain() -> MovieResponse {
        var movieDomain = [Movie]()
        if let movieDTO = movies?.allObjects as? [MovieCDModel] {
            movieDomain = movieDTO.map { $0.toDomain() }
        }
        return .init(page: Int(page),
                     totalPages: Int(totalPages),
                     movies: movieDomain)
    }
}
