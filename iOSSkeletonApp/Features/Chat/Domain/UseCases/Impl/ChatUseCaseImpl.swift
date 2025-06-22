//
//  ChatUseCaseImpl.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 22/6/25.
//

import Foundation
import Factory
import Combine

class ChatUseCaseImpl: ChatUseCase {
    
    // Inject All Repositories Here
    /// @Injected(\.itemRepository) private var itemRepository
    
    private var cancellables = Set<AnyCancellable>()

    init() {

    }
    
    func execute() -> AnyPublisher<Chat, any Error> {
        // return itemRepository.fetchItems()
        Just(Chat.stub())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
