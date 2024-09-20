//
//  MovieListRepository.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

protocol MovieListRepository {
    func getRemotePopularMovies(page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void)
    func getLocalPopularMovies(page: Int, completion: (Result<MovieResponse?, Error>) -> Void)
    func savePopularMovies(movieResponse: MovieResponse)
}
