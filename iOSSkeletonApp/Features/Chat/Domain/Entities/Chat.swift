//
//  Chat.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 22/6/25.
//

import Foundation

// MARK: - Entity
struct Chat: Equatable, Identifiable {
    let id: String
    
}

// MARK: - Mappings to DTO
extension Chat {
    func toDTO() -> ChatDTO {
        return .init(id: Int(id) ?? 0)
    }
}

// MARK: - Mappings to CoreData Model
extension Chat {
//    func toCDModel() -> ChatCDModel {
//        return .init(id: 0)
//    }
}

// MARK: - Stub
extension Chat {
    static func stub(id: String = "1111") -> Self {
        Chat(id: id)
    }
}
