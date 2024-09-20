//
//  MovieListUseCase.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

protocol MovieListUseCase {
    func getPopularMovies(page: Int, cached: @escaping (MovieResponse?) -> Void, completion: @escaping (Result<MovieResponse, Error>) -> Void) 
}
