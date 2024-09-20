//
//  MovieListRepositoryImpl.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation
import Moya

class MovieListRepositoryImpl: MovieListRepository {
    
    private let movieApiDataSource: MoyaProvider<MovieAPI>
    private let movieLocalDataSource: RealmDataSource<MovieResponseRModel>

    init(movieApiDataSource: MoyaProvider<MovieAPI>, movieLocalDataSource: RealmDataSource<MovieResponseRModel>) {
        self.movieApiDataSource = movieApiDataSource
        self.movieLocalDataSource = movieLocalDataSource
    }

    private func fetchPopularMovies(page: Int, completion: @escaping (Result<MovieResponseDTO, Error>) -> ()) {
        movieApiDataSource.request(target: .getMovieList(page: page), completion: completion)
    }
    
    func getRemotePopularMovies(page: Int, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        fetchPopularMovies(page: page) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieResponseDTO):
                let movieResponse = movieResponseDTO.toDomain()
                completion(.success(movieResponse))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getLocalPopularMovies(page: Int, completion: (Result<MovieResponse?, Error>) -> Void) {
        do {
            let predicate = NSPredicate(format: "page = \(page)")
            let movieResponse = try movieLocalDataSource.filter(predicate: predicate).first?.toDomain()
            completion(.success(movieResponse))
        } catch {
            completion(.failure(error))
        }
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

