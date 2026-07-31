//
//  Environment.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

enum ConfigKey: String {
    case environment = "Environment"
    case appName = "CFBundleName"
    case versionNumber = "CFBundleShortVersionString"
    case buildNumber = "CFBundleVersion"

    case apiEndpointUrl = "ApiEndpointUrl"
    case photoEndpointUrl = "PhotoEndpointUrl"
    case accessTokenAuthen = "AccessTokenAuthen"
}

enum Environment: String {
    case dev = "Dev"
    case qc = "QC"
    case uat = "UAT"
    case production = "Production"

    static var current: Environment {
        let environmentName = getConfigValue(for: .environment)
        return Environment(rawValue: environmentName) ?? .dev
    }

    static var appName: String {
        return getConfigValue(for: .appName)
    }

    static var buildNumber: String {
        return getConfigValue(for: .buildNumber)
    }

    static var versionNumber: String {
        return getConfigValue(for: .versionNumber)
    }

    static var apiEndpointUrl: String {
        return getConfigValue(for: .apiEndpointUrl)
    }

    static var photoEndpointUrl: String {
        return getConfigValue(for: .photoEndpointUrl)
    }

    static var accessTokenAuthen: String {
        return getConfigValue(for: .accessTokenAuthen)
    }

    private static func getConfigValue(for key: ConfigKey) -> String {
        guard let value = Bundle.main.infoDictionary?[key.rawValue] as? String else {
            AppLogger.application.error("Missing config for key: \(key.rawValue)")
            return ""
        }
        return value
    }

    /// Logs a loud, actionable message when configuration is incomplete.
    ///
    /// Call this at launch. Without it, an empty `ACCESS_TOKEN_AUTHEN` shows up
    /// much later as an unexplained 401 from the API.
    static func validate() {
        AppLogger.application.info(
            "Running \(current.rawValue, privacy: .public) build \(versionNumber, privacy: .public) (\(buildNumber, privacy: .public))"
        )

        if accessTokenAuthen.isEmpty {
            AppLogger.application.error("""
                ACCESS_TOKEN_AUTHEN is empty — every API call will fail with 401.
                Copy Core/Configuration/Secrets/Secrets.xcconfig.template to \
                Secrets.\(current.rawValue).xcconfig and fill in your TMDB token.
                """)
        }

        if apiEndpointUrl.isEmpty {
            AppLogger.application.error("API_ENDPOINT_URL is empty — check the \(current.rawValue, privacy: .public) .xcconfig.")
        }
    }
}
