//
//  MovieListRepositoryImpl2.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 11/09/2024.
//

import Foundation
import Moya

class MovieListRepositoryImpl2: MovieListRepository2 {

    private let movieApiDataSource: MoyaProvider<MovieAPI>
    private let movieLocalDataSource: RealmDataSource<MovieResponseRModel>
    
    init(movieApiDataSource: MoyaProvider<MovieAPI>, movieLocalDataSource: RealmDataSource<MovieResponseRModel>) {
        self.movieApiDataSource = movieApiDataSource
        self.movieLocalDataSource = movieLocalDataSource
    }

    func getRemotePopularMovies(page: Int) async throws -> MovieResponse {
        let movieResponseDTO: MovieResponseDTO = try await movieApiDataSource.requestAsync(
            target: .getMovieList(page: page),
            decodingType: MovieResponseDTO.self
        )
        return movieResponseDTO.toDomain()
    }

    func getLocalPopularMovies(page: Int) async throws -> MovieResponse? {
        let predicate = NSPredicate(format: "page = %d", page)
        let realmResult = try movieLocalDataSource.filter(predicate: predicate)
        return realmResult.first?.toDomain()
    }

    func savePopularMovies(movieResponse: MovieResponse) {
        do {
            let movieResponseRModel = movieResponse.toReamModel()
            try movieLocalDataSource.createOrUpdate(item: movieResponseRModel)
        } catch {
            print("Failed to save popular movies: \(error)")
        }
    }
}

