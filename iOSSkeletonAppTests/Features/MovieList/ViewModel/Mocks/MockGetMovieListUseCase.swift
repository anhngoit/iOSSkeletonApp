//
//  MockGetMovieListUseCase.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 20/6/25.
//

import Foundation
import Combine

final class MockGetMovieListUseCase: GetMovieListUseCase {
    var result: Result<MoviePage, Error>?

    func execute() -> AnyPublisher<MoviePage, Error> {
        switch result {
        case .success(let page):
            return Just(page)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main) // ensure UI update
                .eraseToAnyPublisher()
        case .failure(let error):
            return Fail(error: error)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        case .none:
            return Empty().eraseToAnyPublisher()
        }
    }
}
