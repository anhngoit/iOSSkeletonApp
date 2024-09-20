//
//  MovieDetailRepositoryImpl.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation
import Moya

class MovieDetailRepositoryImpl: MovieDetailRepository {
    
    private let movieApiDataSource: MoyaProvider<MovieAPI>
    private let movieDetailLocalDataSource: RealmDataSource<MovieRModel>

    init(movieApiDataSource: MoyaProvider<MovieAPI>, movieDetailLocalDataSource: RealmDataSource<MovieRModel>) {
        self.movieApiDataSource = movieApiDataSource
        self.movieDetailLocalDataSource = movieDetailLocalDataSource
    }
    
    private func fetchMovieDetail(id: String, completion: @escaping (Result<MovieDTO, Error>) -> ()) {
        movieApiDataSource.request(target: .getMovieDetail(id: id), completion: completion)
    }

    func getRemoteMovieDetail(id: String, completion: @escaping (Result<Movie, Error>) -> Void) {
        fetchMovieDetail(id: id) {  [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieDTO):
                let movie = movieDTO.toDomain()
                completion(.success(movie))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getLocalMovieDetail(id: String, completion: (Result<Movie?, Error>) -> Void) {
        do {
            let movie = try movieDetailLocalDataSource.read(byId: Int(id))?.toDomain()
            completion(.success(movie))
        } catch {
            completion(.failure(error))
        }
    }
    
    func saveMovieDetail(movie: Movie) {
        do {
            let movieRModel = movie.toRealmModel()
            try movieDetailLocalDataSource.createOrUpdate(item: movieRModel)
        } catch {
            print("Failed to save movie: \(error)")
        }
    }
}

