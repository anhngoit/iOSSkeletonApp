//
//  NavigationStackCoordinatorTests.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import Quick
import Nimble
@testable import iOSSkeletonApp

class NavigationStackCoordinatorTests: QuickSpec {
    // swiftlint:disable:next function_body_length
    override class func spec() {
        var coordinator: NavigationStackCoordinator!

        beforeEach {
            coordinator = NavigationStackCoordinator()
        }

        afterEach {
            coordinator = nil
        }

        describe("NavigationStackCoordinator") {

            context("when a root coordinator is set") {
                it("starts it and exposes it") {
                    let root = MockCoordinator(name: "root")
                    coordinator.setRootCoordinator(root)

                    expect(root.startCallCount).to(equal(1))
                    expect(coordinator.rootCoordinator).to(beIdenticalTo(root))
                }

                it("tears the previous root down exactly once") {
                    var dismissedCount = 0
                    let first = MockCoordinator(name: "first")
                    coordinator.setRootCoordinator(first) { dismissedCount += 1 }

                    coordinator.setRootCoordinator(MockCoordinator(name: "second"))

                    expect(first.stopCallCount).to(equal(1))
                    expect(dismissedCount).to(equal(1))
                }

                it("pops the stack before swapping the root") {
                    coordinator.setRootCoordinator(MockCoordinator(name: "first"))
                    let pushed = MockCoordinator(name: "pushed")
                    coordinator.push(pushed)

                    coordinator.setRootCoordinator(MockCoordinator(name: "second"))

                    expect(coordinator.stackCoordinators).to(beEmpty())
                    expect(pushed.stopCallCount).to(equal(1))
                }
            }

            context("when a coordinator is pushed") {
                it("starts it and appends it to the stack") {
                    let pushed = MockCoordinator(name: "pushed")
                    coordinator.push(pushed)

                    expect(pushed.startCallCount).to(equal(1))
                    expect(coordinator.stackCoordinators).to(haveCount(1))
                }

                it("stops it and fires the callback on a programmatic pop") {
                    var dismissed = false
                    let pushed = MockCoordinator(name: "pushed")
                    coordinator.push(pushed) { dismissed = true }

                    coordinator.pop()

                    expect(dismissed).to(beTrue())
                    expect(pushed.stopCallCount).to(equal(1))
                    expect(coordinator.stackCoordinators).to(beEmpty())
                }

                // The behaviour the whole design rests on: SwiftUI writes a
                // truncated path back through the binding on a swipe-back, and
                // the `didSet` diff is the only thing that notices.
                it("stops it and fires the callback on an interactive pop") {
                    var dismissed = false
                    let pushed = MockCoordinator(name: "pushed")
                    coordinator.push(pushed) { dismissed = true }

                    coordinator.simulateInteractivePop(keeping: 0)

                    expect(dismissed).to(beTrue())
                    expect(pushed.stopCallCount).to(equal(1))
                }
            }

            context("when popping several screens at once") {
                it("tears every popped coordinator down exactly once") {
                    let first = MockCoordinator(name: "first")
                    let second = MockCoordinator(name: "second")
                    coordinator.push(first)
                    coordinator.push(second)

                    coordinator.popToRoot()

                    expect(first.stopCallCount).to(equal(1))
                    expect(second.stopCallCount).to(equal(1))
                    expect(coordinator.stackCoordinators).to(beEmpty())
                }

                it("pops back to a specific coordinator") {
                    let keep = MockCoordinator(name: "keep")
                    let discard = MockCoordinator(name: "discard")
                    coordinator.push(keep)
                    coordinator.push(discard)

                    coordinator.pop(to: keep)

                    expect(coordinator.stackCoordinators).to(haveCount(1))
                    expect(discard.stopCallCount).to(equal(1))
                    expect(keep.stopCallCount).to(equal(0))
                }

                it("is a no-op for a coordinator that is not on the stack") {
                    let pushed = MockCoordinator(name: "pushed")
                    coordinator.push(pushed)

                    coordinator.pop(to: MockCoordinator(name: "stranger"))

                    expect(coordinator.stackCoordinators).to(haveCount(1))
                    expect(pushed.stopCallCount).to(equal(0))
                }
            }

            context("when a sheet is presented") {
                it("starts it, and tears it down when cleared") {
                    var dismissed = false
                    let sheet = MockCoordinator(name: "sheet")
                    coordinator.setSheetCoordinator(sheet) { dismissed = true }

                    expect(sheet.startCallCount).to(equal(1))
                    expect(coordinator.sheetCoordinator).to(beIdenticalTo(sheet))

                    coordinator.setSheetCoordinator(nil)

                    expect(dismissed).to(beTrue())
                    expect(sheet.stopCallCount).to(equal(1))
                    expect(coordinator.sheetCoordinator).to(beNil())
                }
            }

            context("when a full screen cover is presented") {
                it("starts it, and tears it down when cleared") {
                    let cover = MockCoordinator(name: "cover")
                    coordinator.setFullScreenCoverCoordinator(cover)

                    expect(cover.startCallCount).to(equal(1))

                    coordinator.setFullScreenCoverCoordinator(nil)

                    expect(cover.stopCallCount).to(equal(1))
                    expect(coordinator.fullScreenCoverCoordinator).to(beNil())
                }
            }

            context("when the whole stack is stopped") {
                it("tears down the root, the modals and every pushed screen") {
                    let root = MockCoordinator(name: "root")
                    let pushed = MockCoordinator(name: "pushed")
                    let sheet = MockCoordinator(name: "sheet")
                    let cover = MockCoordinator(name: "cover")
                    coordinator.setRootCoordinator(root)
                    coordinator.push(pushed)
                    coordinator.setSheetCoordinator(sheet)
                    coordinator.setFullScreenCoverCoordinator(cover)

                    coordinator.stop()

                    expect(root.stopCallCount).to(equal(1))
                    expect(pushed.stopCallCount).to(equal(1))
                    expect(sheet.stopCallCount).to(equal(1))
                    expect(cover.stopCallCount).to(equal(1))
                }
            }
        }
    }
}
