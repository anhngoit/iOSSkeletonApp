//
//  MovieDetailScreenCoordinator.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import SwiftUI

/// The screen emits no actions yet, so `start()` and `stop()` come from the
/// `CoordinatorProtocol` extension and only `toPresentable()` is implemented.
/// When it grows actions, add an `actionsSubject` here exactly as
/// `MovieListScreenCoordinator` does.
@MainActor
final class MovieDetailScreenCoordinator: CoordinatorProtocol {

    private let viewModel: MovieDetailViewModel

    init(movie: Movie) {
        viewModel = MovieDetailViewModel(movie: movie)
    }

    func toPresentable() -> AnyView {
        AnyView(MovieDetailView(viewModel: viewModel))
    }
}
