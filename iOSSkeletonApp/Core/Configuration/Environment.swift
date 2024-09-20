//
//  Environment.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 19/9/24.
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
        return Environment(rawValue: environmentName)!
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
        return Bundle.main.infoDictionary?[key.rawValue] as! String
    }
}