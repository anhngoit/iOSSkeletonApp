//
//  MovieListUseCase2.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation

protocol MovieListUseCase2 {
    func getPopularMovies(page: Int, cached: @escaping (MovieResponse?) -> Void, completion: @escaping (MovieResponse) -> Void) async throws
}
