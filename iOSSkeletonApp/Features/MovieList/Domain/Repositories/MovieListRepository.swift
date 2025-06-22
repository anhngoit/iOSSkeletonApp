//
//  MovieListRepository.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Combine

protocol MovieListRepository {
    func getRemotePopularMovies() -> AnyPublisher<MoviePage, any Error>
    func getLocalPopularMovies() -> AnyPublisher<MoviePage?, Error>
    func savePopularMovies(movieResponse: MoviePage) -> AnyPublisher<Void, Error>
}
