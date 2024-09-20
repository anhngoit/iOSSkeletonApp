//
//  FirstTabCoordinator.swift
//  iOSSkeletonApp
//
//  Created by anh.ngo on 6/9/24.
//

import UIKit

class FirstTabCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        guard let viewController = R.storyboard.movieList.movieListViewController() else { return }
        viewController.viewModel.navigateToMovieDetail = { [weak self] movieId in
            guard let self = self else { return }
            self.showMovieDetailScreen(movieId: movieId)
        }
        navigationController.pushViewController(viewController, animated: false)
    }

    private func showMovieDetailScreen(movieId: String) {
        guard let vc = R.storyboard.movieDetail.movieDetailViewController() else { return }
        vc.movieId = movieId
        navigationController.pushViewController(vc, animated: true)
    }
}

