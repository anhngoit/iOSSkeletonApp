//
//  AppConstants.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

/// Compile-time constants that aren't environment-specific.
///
/// Anything that differs per environment belongs in the `.xcconfig` files and
/// is read through `Environment`, not here.
enum AppConstants {

    enum Network {
        static let requestTimeout: TimeInterval = 60
        static let resourceTimeout: TimeInterval = 120
        static let maxConnectionsPerHost = 5
    }

    enum Cache {
        /// How long to wait on local storage before falling through to the network.
        static let localReadTimeout: TimeInterval = 2
    }
}
