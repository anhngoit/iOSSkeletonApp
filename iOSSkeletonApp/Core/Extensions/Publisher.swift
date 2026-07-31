//
//  Publisher.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Combine
import Moya

extension JSONDecoder {
    /// Shared decoder for API responses.
    ///
    /// The DTOs spell out their own `CodingKeys`, so no key strategy is set
    /// here on purpose — adding `.convertFromSnakeCase` would silently fight
    /// those explicit keys.
    static let api: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
}

extension Publisher where Output == Response, Failure == MoyaError {
    /// Decodes the response body, translating transport and decoding failures
    /// into `AppError` so nothing above the data layer sees a Moya type.
    func decodeResponse<T: Decodable>(to type: T.Type) -> AnyPublisher<T, Error> {
        self
            .mapError { AppError.from($0) as Error }
            .flatMap { response -> AnyPublisher<T, Error> in
                // Moya only treats transport failures as errors; a 401 or 500
                // arrives here as a perfectly good `Response`.
                guard (200..<300).contains(response.statusCode) else {
                    return Fail(error: AppError.from(statusCode: response.statusCode))
                        .eraseToAnyPublisher()
                }
                do {
                    let decoded = try JSONDecoder.api.decode(type, from: response.data)
                    return Just(decoded).setFailureType(to: Error.self).eraseToAnyPublisher()
                } catch {
                    AppLogger.networking.error(
                        "Decoding \(String(describing: type), privacy: .public) failed: \(String(describing: error), privacy: .public)"
                    )
                    return Fail(error: AppError.decoding(detail: String(describing: error)))
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

private extension AppError {
    static func from(statusCode: Int) -> AppError {
        switch statusCode {
        case 401, 403: return .unauthorized
        default: return .server(statusCode: statusCode)
        }
    }

    static func from(_ error: MoyaError) -> AppError {
        if let response = error.response {
            return from(statusCode: response.statusCode)
        }
        guard let urlError = error.errorUserInfo[NSUnderlyingErrorKey] as? URLError else {
            return .unknown(error)
        }
        switch urlError.code {
        case .timedOut:
            return .timeout
        case .notConnectedToInternet, .networkConnectionLost, .dataNotAllowed:
            return .offline
        default:
            return .unknown(error)
        }
    }
}
