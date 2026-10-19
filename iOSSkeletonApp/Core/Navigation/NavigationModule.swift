//
//  NavigationModule.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import Foundation

/// Type-erasing wrapper that lets an arbitrary coordinator be used as a
/// `NavigationStack` path element, a `.sheet(item:)` item, or a stack root.
/// Coordinators themselves are neither `Hashable` nor `Identifiable`; this is
/// what makes SwiftUI navigation work with them.
///
/// Deliberately *not* `@MainActor`: only `tearDown()` touches main-actor state,
/// and leaving the type non-isolated keeps the `Hashable`/`Identifiable`
/// conformances free of `nonisolated` annotations.
final class NavigationModule: Identifiable, Hashable {

    let id = UUID()

    /// `NavigationStack` has a tendency to hold on to path items for longer
    /// than needed. We work around that by nilling the coordinator when the
    /// module is dismissed — which is the only reason this is optional. The
    /// module is just a wrapper, so extra instances living on cost nothing.
    /// https://stackoverflow.com/questions/73885353/
    var coordinator: (any CoordinatorProtocol)?

    private var dismissalCallback: (() -> Void)?

    init(_ coordinator: any CoordinatorProtocol, dismissalCallback: (() -> Void)? = nil) {
        self.coordinator = coordinator
        self.dismissalCallback = dismissalCallback
    }

    /// Nils the callback out *before* invoking it, so a re-entrant teardown can
    /// never fire it twice.
    @MainActor
    func tearDown() {
        coordinator?.stop()
        coordinator = nil

        let callback = dismissalCallback
        dismissalCallback = nil
        callback?()
    }

    static func == (lhs: NavigationModule, rhs: NavigationModule) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
