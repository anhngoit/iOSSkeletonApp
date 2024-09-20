//
//  MoyaProvider.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/06/2024.
//

import Foundation
import Moya

extension MoyaProvider {
    func request<T: Decodable>(target: Target, completion: @escaping (Result<T, Error>) -> ()) {
        self.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(results))
                } catch let error {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }
}

extension MoyaProvider {
    func requestAsync<T: Decodable>(target: Target, decodingType: T.Type) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(T.self, from: response.data)
                        continuation.resume(returning: decodedResponse)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
