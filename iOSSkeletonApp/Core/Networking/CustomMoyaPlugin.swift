//
//  CustomMoyaPlugin.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Moya
import OSLog

final class CustomMoyaPlugin: PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
        guard let urlRequest = request.request else {
            AppLogger.networking.error("Failed to log request: invalid URL request.")
            return
        }
        
        let url = urlRequest.url?.absoluteString ?? "Unknown URL"
        let method = urlRequest.httpMethod ?? "Unknown Method"
        AppLogger.networking.info("📤 Sending request: \(method, privacy: .public) \(url, privacy: .public)")
        
        if let headers = urlRequest.allHTTPHeaderFields {
            AppLogger.networking.debug("📤 Headers: \(headers, privacy: .public)")
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
