//
//  ChatResponse.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 22/6/25.
//

import Foundation

// MARK: - Data Transfer Object
typealias ChatResponse = APIResponse<ChatDTO>

// MARK: - Mappings to Domain
extension ChatResponse {
    func toDomain() -> [Chat] {
        return results.map { $0.toDomain() }
    }
}
