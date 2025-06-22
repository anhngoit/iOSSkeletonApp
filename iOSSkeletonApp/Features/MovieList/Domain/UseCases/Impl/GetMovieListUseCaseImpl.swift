//
//  GetMovieListUseCaseImpl.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Factory
import Combine

class GetMovieListUseCaseImpl: GetMovieListUseCase {
    
    @Injected(\.movieListRepository) private var movieListRepository
    
    private var cancellables = Set<AnyCancellable>()

    init() {

    }
    
    func execute() -> AnyPublisher<MoviePage, any Error> {
        let fallbackPage = MoviePage(page: 0, totalPages: 0, movies: [])
        
        let cached = movieListRepository.getLocalPopularMovies()
            .compactMap { $0 } // unwrap Optional<MoviePage>
            .handleEvents(receiveOutput: { _ in })
            .timeout(.seconds(2), scheduler: DispatchQueue.main, customError: { AppError.timeout })
            .catch { _ in Just(fallbackPage).setFailureType(to: Error.self) }

        let fresh = movieListRepository.getRemotePopularMovies()
            .handleEvents(receiveOutput: { fresh in
                self.movieListRepository.savePopularMovies(movieResponse: fresh)
                    .sink(receiveCompletion: { _ in }, receiveValue: { })
                    .store(in: &self.cancellables)
            })
    
        return cached
            .append(fresh)
            .eraseToAnyPublisher()
    }
}
