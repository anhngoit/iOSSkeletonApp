//
//  MoyaProvider.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Moya
import Combine

/// Holds the in-flight Moya token so the Combine cancel handler can reach it.
private final class RequestTokenBox {
    var token: Moya.Cancellable?
}

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
        Deferred {
            let box = RequestTokenBox()
            return Future<Response, MoyaError> { promise in
                box.token = self.request(target, callbackQueue: callbackQueue, progress: nil) { result in
                    switch result {
                    case .success(let response):
                        promise(.success(response))
                    case .failure(let error):
                        promise(.failure(error))
                    }
                }
            }
            .handleEvents(receiveCancel: { box.token?.cancel() })
        }
        .eraseToAnyPublisher()
    }
}
