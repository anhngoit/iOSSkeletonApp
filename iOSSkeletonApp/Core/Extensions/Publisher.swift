//
//  Publisher.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Combine
import Moya

extension Publisher where Output == Response, Failure == MoyaError {
    func decodeResponse<T: Decodable>(to type: T.Type) -> AnyPublisher<T, Error> {
        self.map(\.data)
            .decode(type: type, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
