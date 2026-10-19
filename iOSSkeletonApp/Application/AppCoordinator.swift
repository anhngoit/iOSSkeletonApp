//
//  AppCoordinator.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import SwiftUI

@MainActor
final class AppCoordinator: ObservableObject, CoordinatorProtocol {

    // MARK: - Output
    @Published var selectedTab: Tab = .firstTab

    // MARK: Private Properties

    /// Each tab keeps its own stack, so switching away and back preserves how
    /// deep the user had navigated.
    private let firstTabStackCoordinator = NavigationStackCoordinator()
    private let secondTabStackCoordinator = NavigationStackCoordinator()

    /// Flow coordinators are referenced by nothing else — the stack only holds
    /// the screens they created — so without these properties their action
    /// subscriptions would die the moment `start()` returned.
    private var firstTabFlowCoordinator: MovieListFlowCoordinator?
    private var secondTabFlowCoordinator: MovieListFlowCoordinator?

    private var hasStarted = false

    // MARK: - CoordinatorProtocol

    /// Deliberately idempotent. `init()` does no work because `@StateObject`
    /// constructs this even on the unit-test path, and `start()` guards itself
    /// because `.task` re-runs whenever the window's content view is
    /// re-identified — a second run would tear down and replace live roots.
    func start() {
        guard !hasStarted else { return }
        hasStarted = true

        let firstFlow = MovieListFlowCoordinator(navigationStackCoordinator: firstTabStackCoordinator)
        firstTabFlowCoordinator = firstFlow
        firstFlow.start()

        let secondFlow = MovieListFlowCoordinator(navigationStackCoordinator: secondTabStackCoordinator)
        secondTabFlowCoordinator = secondFlow
        secondFlow.start()
    }

    func toPresentable() -> AnyView {
        AnyView(MainTabView(appCoordinator: self))
    }

    func stop() {
        firstTabStackCoordinator.stop()
        secondTabStackCoordinator.stop()
    }

    // MARK: - Tabs

    func presentable(for tab: Tab) -> AnyView {
        switch tab {
        case .firstTab:
            return firstTabStackCoordinator.toPresentable()

        case .secondTab:
            return secondTabStackCoordinator.toPresentable()
        }
    }
}
