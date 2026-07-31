//
//  AppError.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

/// Framework-free error type for the domain and presentation layers.
///
/// Moya/Alamofire/Core Data errors are translated into these at the data
/// boundary, so nothing above the repository has to know what HTTP is — and so
/// the UI never has to show a raw `DecodingError` description.
enum AppError: LocalizedError, Equatable {
    case timeout
    case offline
    /// 401/403 — usually a missing or wrong `ACCESS_TOKEN_AUTHEN`.
    case unauthorized
    case server(statusCode: Int)
    /// The response didn't match the expected shape. `detail` is for logs.
    case decoding(detail: String)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .timeout:
            return "Request timed out."
        case .offline:
            return "You appear to be offline."
        case .unauthorized:
            return "Not authorised. Check the API token in your .xcconfig."
        case .server(let statusCode):
            return "The server returned an error (\(statusCode))."
        case .decoding:
            return "Received an unexpected response from the server."
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.timeout, .timeout),
             (.offline, .offline),
             (.unauthorized, .unauthorized):
            return true
        case let (.server(lhsCode), .server(rhsCode)):
            return lhsCode == rhsCode
        case let (.decoding(lhsDetail), .decoding(rhsDetail)):
            return lhsDetail == rhsDetail
        case let (.unknown(lhsError), .unknown(rhsError)):
            return lhsError.localizedDescription == rhsError.localizedDescription
        default:
            return false
        }
    }
}
