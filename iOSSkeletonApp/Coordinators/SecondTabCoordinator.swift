//
//  SecondTabCoordinator.swift
//  iOSSkeletonApp
//
//  Created by anh.ngo on 6/9/24.
//

import Foundation
import SwiftUI

@MainActor
class SecondTabCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let viewModel = MovieListViewModel2(movieListUseCase: DIContainer.shared.movieListUseCase2)
        viewModel.showMovieDetail = { [weak self] id in
            self?.showMovieDetailScreen(movieId: id)
        }
        let swiftUIView = MovieListView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: swiftUIView)
        navigationController.pushViewController(hostingController, animated: false)
    }

    private func showMovieDetailScreen(movieId: String) {
        guard let vc = R.storyboard.movieDetail.movieDetailViewController() else { return }
        vc.movieId = movieId
        navigationController.pushViewController(vc, animated: true)
    }
}
