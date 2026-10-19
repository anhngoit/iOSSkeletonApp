//
//  CoordinatorProtocol.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import SwiftUI

/// A single presentable unit of UI.
///
/// Screen coordinators own a view model and vend its view; container
/// coordinators (`NavigationStackCoordinator`, `AppCoordinator`) vend a shell
/// that hosts other coordinators.
///
/// `@MainActor` is not decorative here: conformers construct `BaseViewModel`
/// subclasses, which are main-actor isolated, and Swift 5 language mode still
/// treats an isolation violation as an error.
@MainActor
protocol CoordinatorProtocol: AnyObject {
    func start()
    func stop()
    func toPresentable() -> AnyView
}

/// Every member has a default, so a screen coordinator with no actions to wire
/// up only has to implement `toPresentable()`.
extension CoordinatorProtocol {

    func start() { }

    func stop() { }

    func toPresentable() -> AnyView {
        AnyView(Text("View not configured"))
    }
}

/// A coordinator that drives a sequence of screens rather than presenting one
/// itself. It is handed a navigation stack by its parent and never vends a view.
@MainActor
protocol FlowCoordinatorProtocol: AnyObject {
    func start()
}
