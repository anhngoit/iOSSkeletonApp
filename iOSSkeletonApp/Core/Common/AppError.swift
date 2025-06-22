//
//  AppError.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

enum AppError: LocalizedError, Equatable {
    case timeout
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .timeout: return "Request timed out."
        case .unknown(let error): return error.localizedDescription
        }
    }
    
    static func == (lhs: AppError, rhs: AppError) -> Bool {
        switch (lhs, rhs) {
        case (.timeout, .timeout): return true
        case let (.unknown(e1), .unknown(e2)):
            return e1.localizedDescription == e2.localizedDescription
        default: return false
        }
    }
}
