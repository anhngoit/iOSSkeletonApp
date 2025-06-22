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

class MovieListViewModelTests: QuickSpec {
    override class func spec() {
        var mockUseCase: MockGetMovieListUseCase!
        var viewModel: MovieListViewModel!
        var cancellables: Set<AnyCancellable>!

        beforeEach {
            mockUseCase = MockGetMovieListUseCase()
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
                    mockUseCase.result = .success(
                        MoviePage(page: 1, totalPages: 1, movies: [expectedMovie])
                    )
                    viewModel = MovieListViewModel()
                    
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
                    mockUseCase.result = .failure(AppError.timeout)
                    viewModel = MovieListViewModel()
                    
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
        }
    }
}
