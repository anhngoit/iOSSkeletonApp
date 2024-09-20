//
//  MovieListUsecaseImpl2.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

class MovieListUseCaseImpl2: MovieListUseCase2 {
    
    private let movieListRepository: MovieListRepository2
        
    init(movieListRepository: MovieListRepository2) {
        self.movieListRepository = movieListRepository
    }
    
    func getPopularMovies(page: Int, cached: @escaping (MovieResponse?) -> Void, completion: @escaping (MovieResponse) -> Void) async throws {
        let cachedResponse = try await movieListRepository.getLocalPopularMovies(page: page)
        cached(cachedResponse)
        
        // Fetch fresh data from remote
        let freshResponse = try await movieListRepository.getRemotePopularMovies(page: page)

        // Save fresh data to the cache
        await movieListRepository.savePopularMovies(movieResponse: freshResponse)
        completion(freshResponse)
    }
}
