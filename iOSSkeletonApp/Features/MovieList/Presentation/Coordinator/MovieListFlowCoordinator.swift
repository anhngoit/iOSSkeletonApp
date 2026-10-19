//
//  MovieListFlowCoordinator.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import Foundation
import Combine

/// Drives the movie browsing flow: the list at the root of the stack, and the
/// detail screen pushed on top of it. It owns no view — the navigation stack it
/// is handed is what gets presented.
@MainActor
final class MovieListFlowCoordinator: FlowCoordinatorProtocol {

    private let navigationStackCoordinator: NavigationStackCoordinator

    private var cancellables = Set<AnyCancellable>()

    /// Retained only so the dismissal callback has something to clear, which
    /// keeps the "the parent owns the child until it is dismissed" invariant
    /// visible rather than implicit.
    private var movieDetailCoordinator: MovieDetailScreenCoordinator?

    init(navigationStackCoordinator: NavigationStackCoordinator) {
        self.navigationStackCoordinator = navigationStackCoordinator
    }

    func start() {
        let coordinator = MovieListScreenCoordinator()

        // Subscribe before presenting: `setRootCoordinator` calls the
        // coordinator's `start()` synchronously from its `didSet`.
        coordinator.actions
            .sink { [weak self] action in
                switch action {
                case .selectMovie(let movie):
                    self?.showMovieDetail(movie)
                }
            }
            .store(in: &cancellables)

        navigationStackCoordinator.setRootCoordinator(coordinator)
    }

    // MARK: Private Methods

    private func showMovieDetail(_ movie: Movie) {
        let coordinator = MovieDetailScreenCoordinator(movie: movie)

        // Fires for a programmatic pop and a swipe-back alike. `[weak self]` is
        // load-bearing: the stack holds the module, the module holds this
        // closure, and this flow holds the stack.
        //
        // When the detail screen grows actions, its subscription belongs in a
        // per-presentation `AnyCancellable` cleared here — putting it in
        // `cancellables` would leak one subscription per push.
        navigationStackCoordinator.push(coordinator) { [weak self] in
            self?.movieDetailCoordinator = nil
        }

        movieDetailCoordinator = coordinator
    }
}
