//
//  ChatImpl.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 22/6/25.
//

import Foundation
import Factory
import Combine

class ChatRepositoryImpl: ChatRepository {

    // Inject Local DataSource and API DataSource here
    
    init() {
        
    }
    
    func fetchItems() -> AnyPublisher<[Chat], Error> {
        // Implement your data fetching logic here (API, local DB, etc.)
        Just([Chat.stub()])
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
