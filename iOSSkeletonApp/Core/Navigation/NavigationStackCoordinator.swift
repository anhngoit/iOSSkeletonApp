//
//  NavigationStackCoordinator.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import SwiftUI

/// Owns a `NavigationStack` and drives it from imperative calls, so flow
/// coordinators decide what is on screen instead of views doing it themselves.
///
/// Lifecycle lives in the `didSet` observers rather than in the methods, which
/// is what makes programmatic and interactive dismissal behave identically.
///
/// Uses `ObservableObject` rather than `@Observable` to match the rest of the
/// codebase. If SwiftUI ever complains about "Publishing changes from within
/// view updates", switching *only* this type to `@Observable` + `@Bindable`
/// fixes it and requires no changes anywhere else.
@MainActor
final class NavigationStackCoordinator: ObservableObject, CoordinatorProtocol {

    // MARK: - Modules
    // `fileprivate` so that only `NavigationStackCoordinatorView`, at the
    // bottom of this file, can bind to them. Everyone else goes through the
    // `set…`/`push`/`pop` methods.

    @Published fileprivate var rootModule: NavigationModule? {
        didSet {
            oldValue?.tearDown()
            rootModule?.coordinator?.start()
        }
    }

    @Published fileprivate var sheetModule: NavigationModule? {
        didSet {
            oldValue?.tearDown()
            sheetModule?.coordinator?.start()
        }
    }

    @Published fileprivate var fullScreenCoverModule: NavigationModule? {
        didSet {
            oldValue?.tearDown()
            fullScreenCoverModule?.coordinator?.start()
        }
    }

    /// SwiftUI writes this back through the binding when the stack is popped
    /// interactively, which makes `didSet` the *only* hook for swipe-back.
    @Published fileprivate var stackModules = [NavigationModule]() {
        didSet { processStackChanges(comparedTo: oldValue) }
    }

    // MARK: - Read-only access

    var rootCoordinator: (any CoordinatorProtocol)? { rootModule?.coordinator }

    var sheetCoordinator: (any CoordinatorProtocol)? { sheetModule?.coordinator }

    var fullScreenCoverCoordinator: (any CoordinatorProtocol)? { fullScreenCoverModule?.coordinator }

    /// The pushed coordinators, excluding the root.
    var stackCoordinators: [any CoordinatorProtocol] { stackModules.compactMap(\.coordinator) }

    // MARK: - Presentation

    /// Replacing the root discards the whole stack.
    func setRootCoordinator(_ coordinator: (any CoordinatorProtocol)?,
                            animated: Bool = true,
                            dismissalCallback: (() -> Void)? = nil) {
        guard let coordinator else {
            rootModule = nil
            return
        }

        if rootModule?.coordinator === coordinator {
            fatalError("Cannot use the same coordinator more than once")
        }

        popToRoot(animated: false)

        withTransaction(Self.transaction(animated: animated)) {
            rootModule = NavigationModule(coordinator, dismissalCallback: dismissalCallback)
        }
    }

    /// - Parameter dismissalCallback: fires on a programmatic pop *and* on an
    ///   interactive swipe-back. Capture `self` weakly in it — the stack holds
    ///   the module, the module holds the closure, and the flow coordinator
    ///   holds the stack, so a strong capture closes a retain cycle.
    func push(_ coordinator: any CoordinatorProtocol,
              animated: Bool = true,
              dismissalCallback: (() -> Void)? = nil) {
        withTransaction(Self.transaction(animated: animated)) {
            stackModules.append(NavigationModule(coordinator, dismissalCallback: dismissalCallback))
        }
    }

    func pop(animated: Bool = true) {
        withTransaction(Self.transaction(animated: animated)) {
            _ = stackModules.popLast()
        }
    }

    func popToRoot(animated: Bool = true) {
        guard !stackModules.isEmpty else { return }

        withTransaction(Self.transaction(animated: animated)) {
            stackModules.removeAll()
        }
    }

    /// No-op when `coordinator` is neither the root nor on the stack.
    func pop(to coordinator: any CoordinatorProtocol, animated: Bool = true) {
        if rootCoordinator === coordinator {
            popToRoot(animated: animated)
        } else if stackCoordinators.contains(where: { $0 === coordinator }) {
            withTransaction(Self.transaction(animated: animated)) {
                while let last = stackCoordinators.last, last !== coordinator {
                    _ = stackModules.popLast()
                }
            }
        }
    }

    // MARK: - CoordinatorProtocol

    func toPresentable() -> AnyView {
        AnyView(NavigationStackCoordinatorView(coordinator: self))
    }

    func stop() {
        rootModule?.tearDown()
        sheetModule?.tearDown()
        fullScreenCoverModule?.tearDown()
        stackModules.forEach { $0.tearDown() }
    }

    // MARK: - Private

    private func processStackChanges(comparedTo oldValue: [NavigationModule]) {
        for change in stackModules.difference(from: oldValue) {
            switch change {
            case .insert(_, let module, _):
                module.coordinator?.start()

            case .remove(_, let module, _):
                module.tearDown()
            }
        }
    }

    /// Animation is controlled through a `Transaction` rather than
    /// `withAnimation`, so that `animated: false` suppresses the transition
    /// without suppressing the state change.
    fileprivate static func transaction(animated: Bool) -> Transaction {
        var transaction = Transaction()
        transaction.disablesAnimations = !animated
        return transaction
    }
}

// MARK: - Modal presentation
/// Split into an extension purely to keep the primary declaration under
/// SwiftLint's `type_body_length` threshold, which `strict: true` promotes to
/// an error. The rule only counts the primary declaration.
extension NavigationStackCoordinator {

    func setSheetCoordinator(_ coordinator: (any CoordinatorProtocol)?,
                             animated: Bool = true,
                             dismissalCallback: (() -> Void)? = nil) {
        guard let coordinator else {
            sheetModule = nil
            return
        }

        if sheetModule?.coordinator === coordinator {
            fatalError("Cannot use the same coordinator more than once")
        }

        withTransaction(Self.transaction(animated: animated)) {
            sheetModule = NavigationModule(coordinator, dismissalCallback: dismissalCallback)
        }
    }

    func setFullScreenCoverCoordinator(_ coordinator: (any CoordinatorProtocol)?,
                                       animated: Bool = true,
                                       dismissalCallback: (() -> Void)? = nil) {
        guard let coordinator else {
            fullScreenCoverModule = nil
            return
        }

        if fullScreenCoverModule?.coordinator === coordinator {
            fatalError("Cannot use the same coordinator more than once")
        }

        withTransaction(Self.transaction(animated: animated)) {
            fullScreenCoverModule = NavigationModule(coordinator, dismissalCallback: dismissalCallback)
        }
    }
}

// MARK: - View

private struct NavigationStackCoordinatorView: View {

    /// `@ObservedObject`, not `@StateObject`: the coordinator is owned by
    /// whoever created it, and this view is rebuilt from `toPresentable()` on
    /// every container render.
    @ObservedObject var coordinator: NavigationStackCoordinator

    var body: some View {
        NavigationStack(path: $coordinator.stackModules) {
            coordinator.rootModule?.coordinator?.toPresentable()
                .id(coordinator.rootModule?.id)
                .navigationDestination(for: NavigationModule.self) { module in
                    module.coordinator?.toPresentable()
                        .id(module.id)
                }
        }
        .sheet(item: $coordinator.sheetModule) { module in
            module.coordinator?.toPresentable()
                .id(module.id)
        }
        .fullScreenCover(item: $coordinator.fullScreenCoverModule) { module in
            module.coordinator?.toPresentable()
                .id(module.id)
        }
    }
}

// MARK: - Testing

#if DEBUG
extension NavigationStackCoordinator {

    /// Reproduces what SwiftUI does to the path binding on an interactive
    /// swipe-back. There is no other way to exercise the dismissal callback for
    /// a gesture-driven pop from a unit test.
    func simulateInteractivePop(keeping count: Int) {
        stackModules = Array(stackModules.prefix(count))
    }
}
#endif
