//
//  MockCoordinator.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import SwiftUI
@testable import iOSSkeletonApp

/// Hand-written rather than generated: the AutoMockable stencil emits a
/// `nonisolated ... @unchecked Sendable` class with `NSLock`-guarded counters,
/// which cannot conform to `@MainActor CoordinatorProtocol`, and it records no
/// call ordering — which is exactly what the teardown tests assert on.
@MainActor
final class MockCoordinator: CoordinatorProtocol {

    enum Event: Equatable {
        case start
        case stop
    }

    let name: String

    private(set) var events: [Event] = []

    var startCallCount: Int { events.filter { $0 == .start }.count }

    var stopCallCount: Int { events.filter { $0 == .stop }.count }

    init(name: String = "mock") {
        self.name = name
    }

    func start() {
        events.append(.start)
    }

    func stop() {
        events.append(.stop)
    }

    func toPresentable() -> AnyView {
        AnyView(Text(name))
    }
}
