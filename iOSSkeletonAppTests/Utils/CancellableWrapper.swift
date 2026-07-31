//
//  CancellableWrapper.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 20/6/25.
//

import Moya
@testable import iOSSkeletonApp

/// Simple wrapper that conforms to Moya's Cancellable protocol for mocking purposes.
class CancellableWrapper: Moya.Cancellable {
    private(set) var isCancelled = false
    func cancel() {
        isCancelled = true
    }
}
