//
//  MovieListViewModelTests.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 20/6/25.
//

import Quick
import Nimble
import Combine
import Factory
import Foundation
@testable import iOSSkeletonApp

class MovieListViewModelTests: QuickSpec {
    // swiftlint:disable:next function_body_length
    override class func spec() {
        var mockUseCase: GetMovieListUseCaseMock!
        var viewModel: MovieListViewModel!
        var cancellables: Set<AnyCancellable>!

        func stubExecute(returns page: MoviePage) {
            mockUseCase.executeReturnValue = Just(page)
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }

        beforeEach {
            mockUseCase = GetMovieListUseCaseMock()
            Container.shared.movieListUseCase.register { mockUseCase }
            cancellables = []
        }

        afterEach {
            Container.shared.reset()
            viewModel = nil
            cancellables = nil
        }

        describe("MovieListViewModel") {
            context("when movies are loaded successfully") {
                it("updates the movies list") {
                    let expectedMovie = Movie.stub()
                    stubExecute(returns: MoviePage(page: 1, totalPages: 1, movies: [expectedMovie]))
                    viewModel = MovieListViewModel()
                    viewModel.onAppear()

                    waitUntil(timeout: .seconds(2)) { done in
                        viewModel.$movies
                            .dropFirst()
                            .sink { movies in
                                expect(movies).to(equal([expectedMovie]))
                                done()
                            }
                            .store(in: &cancellables)
                    }
                }
            }

            context("when loading fails") {
                it("sets the activeAlert to error") {
                    mockUseCase.executeReturnValue = Fail<MoviePage, Error>(error: AppError.timeout)
                        .receive(on: DispatchQueue.main)
                        .eraseToAnyPublisher()
                    viewModel = MovieListViewModel()
                    viewModel.onAppear()

                    waitUntil(timeout: .seconds(2)) { done in
                        viewModel.$activeAlert
                            .dropFirst()
                            .sink { alert in
                                guard case .error(let msg)? = alert else { return }
                                expect(msg).to(contain("timed out"))
                                done()
                            }
                            .store(in: &cancellables)
                    }
                }
            }

            // The generated mock's call count makes the load-once guard
            // directly testable — a hand-written double needed a bespoke
            // counter for this.
            context("when onAppear fires more than once") {
                it("only loads the first time") {
                    stubExecute(returns: MoviePage(page: 1, totalPages: 1, movies: [Movie.stub()]))
                    viewModel = MovieListViewModel()

                    viewModel.onAppear()
                    viewModel.onAppear()
                    viewModel.onAppear()

                    // SwiftUI re-evaluates `.task` when a view is recreated;
                    // without the guard this fired a request every time.
                    expect(mockUseCase.executeCallsCount).to(equal(1))
                }
            }

            context("when the use case emits cached then fresh pages") {
                it("keeps the latest page and clears the empty state") {
                    let cached = MoviePage(page: 1, totalPages: 1, movies: [])
                    let fresh = MoviePage(page: 1, totalPages: 1, movies: [Movie.stub(id: "fresh")])

                    // The closure hook drives a multi-value publisher, which a
                    // single `executeReturnValue` cannot express.
                    mockUseCase.executeClosure = {
                        [cached, fresh].publisher
                            .setFailureType(to: Error.self)
                            .receive(on: DispatchQueue.main)
                            .eraseToAnyPublisher()
                    }
                    viewModel = MovieListViewModel()
                    viewModel.onAppear()

                    // Polled rather than observed through `$movies`: `@Published`
                    // fires on `willSet`, so inside that sink `movies` is still
                    // the old value and the `isEmpty` assignment on the next
                    // line hasn't happened yet. Asserting there would test a
                    // half-applied state that no SwiftUI observer ever sees.
                    expect(viewModel.movies.first?.id).toEventually(equal("fresh"), timeout: .seconds(2))
                    expect(viewModel.isEmpty).to(beFalse())
                }
            }
        }
    }
}
