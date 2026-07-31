//
//  GetMovieListUseCaseImpl.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Factory
import Combine

final class GetMovieListUseCaseImpl: GetMovieListUseCase {

    @Injected(\.movieListRepository) private var movieListRepository

    func execute() -> AnyPublisher<MoviePage, any Error> {
        let repository = movieListRepository

        let cached = repository.getLocalPopularMovies()
            .compactMap { $0 }
            .timeout(.seconds(AppConstants.Cache.localReadTimeout), scheduler: DispatchQueue.main, customError: { AppError.timeout })
            .catch { error -> Empty<MoviePage, Error> in
                AppLogger.localStorage.info(
                    "Cache miss for popular movies: \(error.localizedDescription, privacy: .public)"
                )
                return Empty(completeImmediately: true)
            }

        let fresh = repository.getRemotePopularMovies()
            .flatMap { page in
                repository.savePopularMovies(movieResponse: page)
                    .catch { error -> Just<Void> in
                        AppLogger.localStorage.error(
                            "Failed to cache popular movies: \(error.localizedDescription, privacy: .public)"
                        )
                        return Just(())
                    }
                    .map { _ in page }
                    .setFailureType(to: Error.self)
            }

        return cached
            .append(fresh)
            .eraseToAnyPublisher()
    }
}
