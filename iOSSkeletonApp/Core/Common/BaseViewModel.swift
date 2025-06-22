//
//  BaseViewModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Combine
import Factory

@MainActor
class BaseViewModel: ObservableObject {

    @Published var isLoading = false

    @Injected(\.appState) var appState

    var cancellables = Set<AnyCancellable>()
}
