//
//  MovieListRepositoryImpl.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Factory
import Combine

class MovieListRepositoryImpl: MovieListRepository {

    @Injected(\.movieApiDataSource) private var movieApiDataSource
    @Injected(\.movieLocalDataSource) private var movieLocalDataSource
    
    init() {
        
    }
    
    func getRemotePopularMovies() -> AnyPublisher<MoviePage, any Error> {
        movieApiDataSource.requestPublisher(.getMovieList(page: 1))
            .decodeResponse(to: MovieResponse.self)
            .map { response in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }

    func getLocalPopularMovies() -> AnyPublisher<MoviePage?, Error> {
        let predicate = NSPredicate(format: "page = %d", 1)
        // let predicate = #Predicate<MovieResponseSDModel> { $0.page == page }
        return movieLocalDataSource
            .filter(with: predicate)
            .map { $0.first?.toDomain() }
            .eraseToAnyPublisher()
    }

    func savePopularMovies(movieResponse: MoviePage) -> AnyPublisher<Void, Error> {
        let model = movieResponse.toCDModel()

        return movieLocalDataSource
            .createOrUpdate(item: model)
            .eraseToAnyPublisher()
    }
}
