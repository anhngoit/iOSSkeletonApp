//
//  AppLogger.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import OSLog

struct AppLogger {
    static let bundleIdentifier = Bundle.main.bundleIdentifier ?? ""
    
    static let application = Logger(subsystem: AppLogger.bundleIdentifier, category: "Application")
    static let di = Logger(subsystem: AppLogger.bundleIdentifier, category: "DI")
    static let localStorage = Logger(subsystem: AppLogger.bundleIdentifier, category: "LocalStorage")
    static let networking = Logger(subsystem: Bundle.main.bundleIdentifier ?? "", category: "Networking")
}
