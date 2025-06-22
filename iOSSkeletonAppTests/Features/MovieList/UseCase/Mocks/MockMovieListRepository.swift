//
//  MockMovieListRepository.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 20/6/25.
//

import Foundation
import Combine

final class MockMovieListRepository: MovieListRepository {
    var remoteResult: Result<MoviePage, Error>?
    var localResult: Result<MoviePage?, Error>?
    var savedMoviePage: MoviePage?
    
    func getRemotePopularMovies() -> AnyPublisher<MoviePage, Error> {
        switch remoteResult {
        case .success(let page):
            return Just(page)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .none:
            return Empty().eraseToAnyPublisher()
        }
    }
    
    func getLocalPopularMovies() -> AnyPublisher<MoviePage?, Error> {
        switch localResult {
        case .success(let page):
            return Just(page)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .none:
            return Empty().eraseToAnyPublisher()
        }
    }
    
    func savePopularMovies(movieResponse: MoviePage) -> AnyPublisher<Void, Error> {
        self.savedMoviePage = movieResponse
        return Just(())
            .setFailureType(to: Error.self)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
