//
//  MoyaProvider.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Moya
import Combine

extension MoyaProvider {
    /// Publishes the raw network response for the given target.
    ///
    /// - Parameters:
    ///   - target: The API target (endpoint) to request.
    ///   - callbackQueue: The queue to invoke the callback on (default: nil; uses provider's default).
    /// - Returns: An `AnyPublisher` that emits the `Response` on success or a `MoyaError` on failure.
    func requestPublisher(
        _ target: Target,
        callbackQueue: DispatchQueue? = nil
    ) -> AnyPublisher<Response, MoyaError> {
        return Future { promise in
            self.request(target, callbackQueue: callbackQueue, progress: nil) { result in
                switch result {
                case .success(let response):
                    promise(.success(response))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
