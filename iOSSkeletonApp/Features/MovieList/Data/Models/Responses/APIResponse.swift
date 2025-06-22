//
//  APIResponse.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let page: Int
    let totalPages: Int
    let results: [T]
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case results = "results"
    }
}
