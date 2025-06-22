//
//  MovieAPI.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Moya
import Alamofire

enum MovieAPI {
    case getMovieList(page: Int)
    case getMovieDetail(id: String)
}

extension MovieAPI: TargetType {
    var headers: [String: String]? {
        var headers: HTTPHeaders = [:]
        headers["accept"] = "application/json"
        headers["Authorization"] = "Bearer " + Environment.accessTokenAuthen
        return headers.dictionary
    }
    
    var baseURL: URL {
        return URL(string: Environment.apiEndpointUrl)!
    }
    
    var path: String {
        switch self {
        case .getMovieList:
            return "/3/movie/popular"
        case .getMovieDetail(let id):
            return "/3/movie/" + id
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getMovieList, .getMovieDetail:
            return .get
        }
    }
    
    var task: Task {
        switch self {
        case .getMovieList(let page):
            return .requestParameters(
                parameters: ["language": "en-US", "page": "\(page)"],
                encoding: URLEncoding.queryString)
        case .getMovieDetail:
            return .requestPlain
        }
    }
}
