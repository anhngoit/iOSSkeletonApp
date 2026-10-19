//
//  MovieListScreenCoordinator.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import SwiftUI
import Combine

/// Re-emitted from the view model's own actions. The extra hop looks redundant
/// while the two enums match, but it is what lets the view model stay unaware
/// of navigation and lets the flow coordinator stay unaware of the view model.
enum MovieListScreenCoordinatorAction {
    case selectMovie(Movie)
}

@MainActor
final class MovieListScreenCoordinator: CoordinatorProtocol {

    private let viewModel: MovieListViewModel

    private var cancellables = Set<AnyCancellable>()

    private let actionsSubject = PassthroughSubject<MovieListScreenCoordinatorAction, Never>()

    var actions: AnyPublisher<MovieListScreenCoordinatorAction, Never> {
        actionsSubject.eraseToAnyPublisher()
    }

    /// The view model cannot be a default argument: default arguments are
    /// evaluated in a *nonisolated* context even inside a `@MainActor` type,
    /// and `MovieListViewModel.init` is main-actor isolated. Coalescing inside
    /// the (isolated) initializer body is the fix, and keeps the seam tests
    /// need to inject a stub.
    init(viewModel: MovieListViewModel? = nil) {
        self.viewModel = viewModel ?? MovieListViewModel()
    }

    func start() {
        viewModel.actions
            .sink { [weak self] action in
                switch action {
                case .selectMovie(let movie):
                    self?.actionsSubject.send(.selectMovie(movie))
                }
            }
            .store(in: &cancellables)
    }

    func stop() {
        cancellables.removeAll()
    }

    func toPresentable() -> AnyView {
        AnyView(MovieListView(viewModel: viewModel))
    }
}

// MARK: - Testing

#if DEBUG
extension MovieListScreenCoordinator {

    /// The flow coordinator builds its own screen coordinator, so a test has no
    /// other handle on the view model to drive the real
    /// view model → screen → flow action chain with.
    var viewModelForTesting: MovieListViewModel { viewModel }
}
#endif
