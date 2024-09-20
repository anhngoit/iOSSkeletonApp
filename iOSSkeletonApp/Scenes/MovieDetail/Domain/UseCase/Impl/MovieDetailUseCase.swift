//
//  MovieDetailUseCase.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

protocol MovieDetailUseCase {
    func getMovieDetail(id: String, cached: @escaping (Movie?) -> Void, completion: @escaping (Result<Movie, Error>) -> Void) 
}
