//
//  ChatViewModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 22/6/25.
//

import Foundation
import Combine
import Factory

@MainActor
class ChatViewModel: BaseViewModel {
    
    // MARK: Use cases
    /// Inject all use cases here
    /// @Injected(\.getItemUseCase) private var getItemUseCase
    
    // MARK: Private Properties

    // MARK: - Output
    /// @Published var items: [Item] = []

    // MARK: - Localized
    /// let navigationTitle = "Title"
    
    // MARK: Init
    override init() {
        super.init()
        doSomething()
    }
    
    // MARK: Private Methods
    private func doSomething() {
        /*
        isLoading = true
        getItemUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    // Handle Showing Error here
                    /// activeAlert = .error(error.localizedDescription)
                    
                }
            } receiveValue: { [weak self] responseValue in
                guard let self = self else { return }
                // Handle Showing response value here
                /// self.items = responseValue.items

            }
            .store(in: &cancellables)
         */
    }
}
