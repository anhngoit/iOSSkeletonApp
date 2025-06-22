//
//  ChatAPI.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 22/6/25.
//

import Foundation
import Moya
import Alamofire

enum ChatAPI {
    case getItem
}

extension ChatAPI: TargetType {
    var headers: [String: String]? {
        var headers: HTTPHeaders = [:]
        // Input Header Here
        
        return headers.dictionary
    }
    
    var baseURL: URL {
        return URL(string: Environment.apiEndpointUrl)!
    }
    
    var path: String {
        switch self {
        case .getItem:
            return ""
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getItem:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getItem:
            return .requestPlain
        }
    }
}
