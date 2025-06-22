//
//  MockMovieLocalDataSource.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 20/6/25.
//

import Foundation
import Moya
import Combine

final class MockMovieLocalDataSource: CDDataSource<MoviePageCDModel>  {
    typealias Model = MoviePageCDModel

    var storedModels: [MoviePageCDModel] = []
    var filterResult: [MoviePageCDModel] = []
    var shouldFail = false

    override func createOrUpdate(item: MoviePageCDModel) -> AnyPublisher<Void, Error> {
        if shouldFail { return Fail(error: NSError(domain: "fail", code: 1)).eraseToAnyPublisher() }
        storedModels.append(item)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    override func createOrUpdate(items: [MoviePageCDModel]) -> AnyPublisher<Void, Error> {
        storedModels.append(contentsOf: items)
        return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    func read(byId id: Any) -> AnyPublisher<MoviePageCDModel?, Error> { fatalError("Not needed") }
    override func readAll() -> AnyPublisher<[MoviePageCDModel], Error> { Just(storedModels).setFailureType(to: Error.self).eraseToAnyPublisher() }
    override func filter(with predicate: NSPredicate) -> AnyPublisher<[MoviePageCDModel], Error> {
        if shouldFail { return Fail(error: NSError(domain: "fail", code: 2)).eraseToAnyPublisher() }
        return Just(filterResult).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
    override func delete(item: MoviePageCDModel) -> AnyPublisher<Void, Error> { Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
    override func delete(items: [MoviePageCDModel]) -> AnyPublisher<Void, Error> { Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
    override func deleteAll() -> AnyPublisher<Void, Error> { Just(()).setFailureType(to: Error.self).eraseToAnyPublisher() }
}
