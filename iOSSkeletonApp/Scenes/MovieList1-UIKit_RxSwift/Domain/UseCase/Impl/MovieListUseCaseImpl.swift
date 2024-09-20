//
//  MovieListUseCaseImpl.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

class MovieListUseCaseImpl: MovieListUseCase {
    
    private let movieListRepository: MovieListRepository
    
    init(movieListRepository: MovieListRepository) {
        self.movieListRepository = movieListRepository
    }

    func getPopularMovies(page: Int, cached: @escaping (MovieResponse?) -> Void, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        movieListRepository.getLocalPopularMovies(page: page) { [weak self] result in
            guard let self = self else { return }
            if case let .success(movieResponse) = result {
                cached(movieResponse)
            }
            
            movieListRepository.getRemotePopularMovies(page: page) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let movieResponse):
                    movieListRepository.savePopularMovies(movieResponse: movieResponse)
                    completion(.success(movieResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
