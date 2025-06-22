//
//  MockMovieApiDataSource.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 20/6/25.
//

import Foundation
import Moya

class MockMovieApiDataSource: MoyaProvider<MovieAPI> {
    var stubResponse: Data?
    var stubError: Error?

    override func request(_ target: Target, callbackQueue: DispatchQueue? = nil, progress: ProgressBlock? = nil, completion: @escaping Completion) -> Moya.Cancellable {
        if let error = stubError {
            completion(.failure(.underlying(error, nil)))
        } else {
            let response = Response(statusCode: 200, data: stubResponse ?? Data())
            completion(.success(response))
        }
        return CancellableWrapper()
    }
}
