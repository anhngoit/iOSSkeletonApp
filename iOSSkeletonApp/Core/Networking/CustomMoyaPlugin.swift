//
//  CustomMoyaPlugin.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Moya
import OSLog

final class CustomMoyaPlugin: PluginType {

    /// Header names whose values must never reach the log.
    ///
    /// Everything logged here is marked `privacy: .public`, which switches off
    /// the unified log's automatic redaction — so anything left in place is
    /// readable in Console.app and in a sysdiagnose taken from a release build.
    private static let sensitiveHeaders: Set<String> = [
        "authorization", "cookie", "set-cookie", "x-api-key", "proxy-authorization"
    ]

    private static func redacting(_ headers: [String: String]) -> [String: String] {
        headers.reduce(into: [:]) { result, entry in
            let isSensitive = sensitiveHeaders.contains(entry.key.lowercased())
            result[entry.key] = isSensitive ? "<redacted>" : entry.value
        }
    }

    func willSend(_ request: RequestType, target: TargetType) {
        guard let urlRequest = request.request else {
            AppLogger.networking.error("Failed to log request: invalid URL request.")
            return
        }
        
        let url = urlRequest.url?.absoluteString ?? "Unknown URL"
        let method = urlRequest.httpMethod ?? "Unknown Method"
        AppLogger.networking.info("📤 Sending request: \(method, privacy: .public) \(url, privacy: .public)")
        
        if let headers = urlRequest.allHTTPHeaderFields {
            AppLogger.networking.debug("📤 Headers: \(Self.redacting(headers), privacy: .public)")
        }

        #if DEBUG
        if let body = urlRequest.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            AppLogger.networking.debug("📤 Body: \(bodyString, privacy: .public)")
        }
        #endif
        
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        switch result {
        case .success(let response):
            #if DEBUG
            let statusCode = response.statusCode
            let url = response.request?.url?.absoluteString ?? "Unknown URL"
            
            AppLogger.networking.info("📥 Received response: \(statusCode) for \(url, privacy: .public)")
            
            if let responseString = String(data: response.data, encoding: .utf8) {
                AppLogger.networking.debug("📥 Response Body: \(responseString, privacy: .public)")
            }
            #endif
        case .failure(let error):
            let url = error.response?.request?.url?.absoluteString ?? "Unknown URL"
            AppLogger.networking.error("❌ Request failed for \(url, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }
}
