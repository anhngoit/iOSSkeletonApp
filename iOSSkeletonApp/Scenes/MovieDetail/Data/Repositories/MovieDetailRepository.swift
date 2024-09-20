//
//  MovieDetailRepository.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

protocol MovieDetailRepository {
    func getRemoteMovieDetail(id: String, completion: @escaping (Result<Movie, Error>) -> Void)
    func getLocalMovieDetail(id: String, completion: (Result<Movie?, Error>) -> Void)
    func saveMovieDetail(movie: Movie)
}
