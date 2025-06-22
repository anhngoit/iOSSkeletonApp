//
//  ChatDTO.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 22/6/25.
//

import Foundation

struct ChatDTO: Codable {
    let id: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
}

extension ChatDTO: DomainConvertible {
    func toDomain() -> Chat {
        return .init(id: String(id))
    }
}
