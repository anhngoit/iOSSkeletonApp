//
//  MovieListRepository2.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

protocol MovieListRepository2 {
    func getRemotePopularMovies(page: Int) async throws -> MovieResponse
    func getLocalPopularMovies(page: Int) async throws -> MovieResponse?
    func savePopularMovies(movieResponse: MovieResponse) async
    
    
}
