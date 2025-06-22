//
//  GetMovieListUseCase.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Combine

protocol GetMovieListUseCase {
    func execute() -> AnyPublisher<MoviePage, any Error>
}
