//
//  MovieDetailUseCaseImpl.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

class MovieDetailUseCaseImpl: MovieDetailUseCase {
    
    private let movieDetailRepository: MovieDetailRepository
    
    init(movieDetailRepository: MovieDetailRepository) {
        self.movieDetailRepository = movieDetailRepository
    }
    
    func getMovieDetail(id: String, cached: @escaping (Movie?) -> Void, completion: @escaping (Result<Movie, Error>) -> Void) {
        movieDetailRepository.getLocalMovieDetail(id: id) { [weak self] movie in
            guard let self = self else { return }
            if case let .success(movie) = movie {
                cached(movie)
            }
            
            movieDetailRepository.getRemoteMovieDetail(id: id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let movie):
                    movieDetailRepository.saveMovieDetail(movie: movie)
                    completion(.success(movie))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        
       
    }
}
