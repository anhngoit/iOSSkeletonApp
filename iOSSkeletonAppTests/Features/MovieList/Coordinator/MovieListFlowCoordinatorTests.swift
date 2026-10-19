//
//  MovieListFlowCoordinatorTests.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import Quick
import Nimble
import Combine
import Factory
import Foundation
@testable import iOSSkeletonApp

class MovieListFlowCoordinatorTests: QuickSpec {
    // swiftlint:disable:next function_body_length
    override class func spec() {
        var mockUseCase: GetMovieListUseCaseMock!
        var navigationStackCoordinator: NavigationStackCoordinator!
        var flowCoordinator: MovieListFlowCoordinator!

        /// The flow builds a `MovieListViewModel`, which resolves
        /// `@Injected(\.movieListUseCase)` — so the container has to be stubbed
        /// even for the cases that assert nothing about movies.
        beforeEach {
            mockUseCase = GetMovieListUseCaseMock()
            mockUseCase.executeReturnValue = Just(MoviePage(page: 1, totalPages: 1, movies: [Movie.stub()]))
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
            Container.shared.movieListUseCase.register { mockUseCase }

            navigationStackCoordinator = NavigationStackCoordinator()
            flowCoordinator = MovieListFlowCoordinator(
                navigationStackCoordinator: navigationStackCoordinator
            )
        }

        afterEach {
            Container.shared.reset()
            flowCoordinator = nil
            navigationStackCoordinator = nil
        }

        /// Drives the real chain: view model → screen coordinator → flow.
        @MainActor
        func selectFirstMovie() {
            guard let screen = navigationStackCoordinator.rootCoordinator as? MovieListScreenCoordinator else {
                fail("expected a MovieListScreenCoordinator at the root")
                return
            }

            let viewModel = screen.viewModelForTesting
            viewModel.onAppear()
            expect(viewModel.movies).toEventuallyNot(beEmpty(), timeout: .seconds(2))

            viewModel.didSelectItem(at: 0)
        }

        describe("MovieListFlowCoordinator") {

            context("when started") {
                it("sets a movie list screen as the stack root") {
                    flowCoordinator.start()

                    expect(navigationStackCoordinator.rootCoordinator)
                        .to(beAKindOf(MovieListScreenCoordinator.self))
                    expect(navigationStackCoordinator.stackCoordinators).to(beEmpty())
                }
            }

            context("when a movie is selected") {
                it("pushes the movie detail screen") {
                    flowCoordinator.start()

                    selectFirstMovie()

                    expect(navigationStackCoordinator.stackCoordinators).to(haveCount(1))
                    expect(navigationStackCoordinator.stackCoordinators.first)
                        .to(beAKindOf(MovieDetailScreenCoordinator.self))
                }

                it("pops back to the list when the detail screen is dismissed") {
                    flowCoordinator.start()
                    selectFirstMovie()

                    navigationStackCoordinator.pop()

                    expect(navigationStackCoordinator.stackCoordinators).to(beEmpty())
                    expect(navigationStackCoordinator.rootCoordinator)
                        .to(beAKindOf(MovieListScreenCoordinator.self))
                }

                // Swipe-back reaches the flow only through the dismissal
                // callback, so it is worth asserting separately from `pop()`.
                it("handles an interactive dismissal of the detail screen") {
                    flowCoordinator.start()
                    selectFirstMovie()

                    navigationStackCoordinator.simulateInteractivePop(keeping: 0)

                    expect(navigationStackCoordinator.stackCoordinators).to(beEmpty())
                }
            }
        }
    }
}
