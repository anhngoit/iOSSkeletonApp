//
//  GetMovieListUseCaseTests.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 20/6/25.
//

import Quick
import Nimble
import Combine
import Foundation
import Factory
@testable import iOSSkeletonApp

class GetMovieListUseCaseTests: QuickSpec {
    // swiftlint:disable:next function_body_length
    override class func spec() {
        var mockRepository: MovieListRepositoryMock!
        var useCase: GetMovieListUseCaseImpl!
        var cancellables: Set<AnyCancellable>!

        // The generated mock exposes every `…ReturnValue` as an implicitly
        // unwrapped optional, so a method the code under test reaches without a
        // stub traps instead of failing gracefully. `savePopularMovies` is part
        // of the fresh-page chain, so it always needs one.
        func stubSaveSucceeds() {
            mockRepository.savePopularMoviesMovieResponseReturnValue = Just(())
                .setFailureType(to: Error.self)
                .receive(on: DispatchQueue.main)
                .eraseToAnyPublisher()
        }

        beforeEach {
            mockRepository = MovieListRepositoryMock()
            Container.shared.movieListRepository.register { mockRepository }
            useCase = GetMovieListUseCaseImpl()
            cancellables = []
        }

        afterEach {
            Container.shared.reset()
        }

        describe("GetMovieListUseCaseImpl") {
            context("when local and remote fetches are successful") {
                it("returns cached first, then fresh, and saves fresh to repo") {
                    let cached = MoviePage(page: 1, totalPages: 2, movies: [Movie.stub(id: "cached")])
                    let fresh = MoviePage(page: 1, totalPages: 2, movies: [Movie.stub(id: "fresh")])

                    mockRepository.getLocalPopularMoviesReturnValue = Just<MoviePage?>(cached)
                        .setFailureType(to: Error.self)
                        .receive(on: DispatchQueue.main)
                        .eraseToAnyPublisher()
                    mockRepository.getRemotePopularMoviesReturnValue = Just(fresh)
                        .setFailureType(to: Error.self)
                        .receive(on: DispatchQueue.main)
                        .eraseToAnyPublisher()
                    stubSaveSucceeds()

                    var receivedPages: [MoviePage] = []

                    waitUntil(timeout: .seconds(3)) { done in
                        useCase.execute()
                            .sink(receiveCompletion: { _ in },
                                  receiveValue: { receivedPages.append($0) })
                            .store(in: &cancellables)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            expect(receivedPages.count).to(equal(2))
                            expect(receivedPages[0].movies.first?.id).to(equal("cached"))
                            expect(receivedPages[1].movies.first?.id).to(equal("fresh"))

                            // The generated mock records calls and arguments, so
                            // the save can be asserted without a bespoke spy
                            // property on a hand-written double.
                            expect(mockRepository.getLocalPopularMoviesCallsCount).to(equal(1))
                            expect(mockRepository.getRemotePopularMoviesCallsCount).to(equal(1))
                            expect(mockRepository.savePopularMoviesMovieResponseCallsCount).to(equal(1))
                            expect(mockRepository.savePopularMoviesMovieResponseReceivedMovieResponse).to(equal(fresh))
                            done()
                        }
                    }
                }
            }

            context("when the local cache fails") {
                it("emits only the fresh page, with no empty placeholder") {
                    mockRepository.getLocalPopularMoviesReturnValue = Fail<MoviePage?, Error>(error: AppError.timeout)
                        .receive(on: DispatchQueue.main)
                        .eraseToAnyPublisher()
                    let fresh = MoviePage(page: 2, totalPages: 2, movies: [Movie.stub(id: "fresh")])
                    mockRepository.getRemotePopularMoviesReturnValue = Just(fresh)
                        .setFailureType(to: Error.self)
                        .receive(on: DispatchQueue.main)
                        .eraseToAnyPublisher()
                    stubSaveSucceeds()

                    var received: [MoviePage] = []

                    waitUntil(timeout: .seconds(3)) { done in
                        useCase.execute()
                            .sink(receiveCompletion: { _ in },
                                  receiveValue: { received.append($0) })
                            .store(in: &cancellables)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            // A cache miss used to emit an empty placeholder
                            // page, which made the list flash an empty state
                            // before the network answered.
                            expect(received.count).to(equal(1))
                            expect(received[0].movies.first?.id).to(equal("fresh"))
                            done()
                        }
                    }
                }
            }

            context("when caching the fresh page fails") {
                it("still delivers the fresh page to the caller") {
                    let fresh = MoviePage(page: 1, totalPages: 1, movies: [Movie.stub(id: "fresh")])

                    mockRepository.getLocalPopularMoviesReturnValue = Just<MoviePage?>(nil)
                        .setFailureType(to: Error.self)
                        .receive(on: DispatchQueue.main)
                        .eraseToAnyPublisher()
                    mockRepository.getRemotePopularMoviesReturnValue = Just(fresh)
                        .setFailureType(to: Error.self)
                        .receive(on: DispatchQueue.main)
                        .eraseToAnyPublisher()
                    // A write failure is logged and swallowed: failing to
                    // populate the cache must not fail the user's fetch.
                    mockRepository.savePopularMoviesMovieResponseReturnValue =
                        Fail<Void, Error>(error: AppError.unknown(NSError(domain: "disk", code: 1)))
                            .receive(on: DispatchQueue.main)
                            .eraseToAnyPublisher()

                    var received: [MoviePage] = []
                    var failed = false

                    waitUntil(timeout: .seconds(3)) { done in
                        useCase.execute()
                            .sink(receiveCompletion: { completion in
                                if case .failure = completion { failed = true }
                            }, receiveValue: { received.append($0) })
                            .store(in: &cancellables)

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            expect(failed).to(beFalse())
                            expect(received.count).to(equal(1))
                            expect(received[0].movies.first?.id).to(equal("fresh"))
                            done()
                        }
                    }
                }
            }
        }
    }
}
