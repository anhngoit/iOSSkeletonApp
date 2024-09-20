//
//  AppCoordinator.swift
//  iOSSkeletonApp
//
//  Created by anh.ngo on 6/9/24.
//

import UIKit

@MainActor
protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    func start()
}

class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    @MainActor
    func start() {
        let tabBarController = UITabBarController()

        // Setup the coordinators for each tab
        let firstTabCoordinator = FirstTabCoordinator(navigationController: UINavigationController())
        let secondTabCoordinator = SecondTabCoordinator(navigationController: UINavigationController())

        childCoordinators.append(firstTabCoordinator)
        childCoordinators.append(secondTabCoordinator)

        // Start each coordinator
        firstTabCoordinator.start()
        secondTabCoordinator.start()

        // Assign ViewControllers to TabBarController
        tabBarController.viewControllers = [
            firstTabCoordinator.navigationController,
            secondTabCoordinator.navigationController
        ]
        
        firstTabCoordinator.navigationController.tabBarItem = UITabBarItem(title: "UIKit+RxSwift", image: UIImage(systemName: "star.fill"), tag: 0)
        secondTabCoordinator.navigationController.tabBarItem = UITabBarItem(title: "SwiftUI+Combine", image: UIImage(systemName: "heart.fill"), tag: 1)

        // Set up TabBarController as rootViewController
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
}
