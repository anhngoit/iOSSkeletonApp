//
//  MovieListRepositoryTests.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 20/6/25.
//

import Quick
import Nimble
import Combine
import Foundation
import Moya
import Factory
import XCTest

class MovieListRepositorySpec: QuickSpec {
    override class func spec() {
        var repository: MovieListRepositoryImpl!
        var mockApi: MockMovieApiDataSource!
        var mockLocal: MockMovieLocalDataSource!
        var cancellables: Set<AnyCancellable>!

        beforeEach {
            mockApi = MockMovieApiDataSource()
            mockLocal = MockMovieLocalDataSource()
            Container.shared.movieApiDataSource.register { mockApi }
            Container.shared.movieLocalDataSource.register { mockLocal }
            repository = MovieListRepositoryImpl()
            cancellables = []
        }

        afterEach {
            Container.shared.reset()
        }

        describe("MovieListRepositoryImpl") {
            context("getRemotePopularMovies") {
                it("returns decoded movies from API response") {
                    // Prepare a stub movie and response data
                    let movieDTO = MovieDTO(id: 101, title: "Remote", genres: nil, posterPath: nil, backdropPath: nil, overview: nil, releaseDate: nil)
                    let response = MovieResponse(page: 1, totalPages: 1, results: [movieDTO])
                    let data = try! JSONEncoder().encode(response)
                    mockApi.stubResponse = data

                    waitUntil(timeout: .seconds(2)) { done in
                        repository.getRemotePopularMovies()
                            .sink(receiveCompletion: { completion in
                                if case .failure(let error) = completion {
                                    fail("Should not fail: \(error)")
                                }
                            }, receiveValue: { page in
                                expect(page.movies.count).to(equal(1))
                                expect(page.movies.first?.id).to(equal("101"))
                                expect(page.page).to(equal(1))
                                done()
                            })
                            .store(in: &cancellables)
                    }
                }

                it("returns error when API fails") {
                    mockApi.stubError = NSError(domain: "Test", code: 1)
                    waitUntil(timeout: .seconds(2)) { done in
                        repository.getRemotePopularMovies()
                            .sink(receiveCompletion: { completion in
                                if case .failure = completion {
                                    done()
                                }
                            }, receiveValue: { _ in
                                fail("Should not succeed")
                            })
                            .store(in: &cancellables)
                    }
                }
            }

            context("getLocalPopularMovies") {
                it("returns mapped movies from local storage") {
                    // You need a stub for MoviePageCDModel and its toDomain() method
                    let localModel = MoviePageCDModel(page: 1, totalPages: 2, movies: NSSet(), context: CoreDataStack.shared.context)
                    mockLocal.filterResult = [localModel]

                    waitUntil(timeout: .seconds(2)) { done in
                        repository.getLocalPopularMovies()
                            .sink(receiveCompletion: { completion in
                                if case .failure(let error) = completion {
                                    fail("Should not fail: \(error)")
                                }
                            }, receiveValue: { page in
                                expect(page?.page).to(equal(1))
                                done()
                            })
                            .store(in: &cancellables)
                    }
                }
            }

            context("savePopularMovies") {
                it("persists the movie page to local storage") {
                    let movie = Movie.stub(id: "202")
                    let moviePage = MoviePage(page: 2, totalPages: 2, movies: [movie])
                    waitUntil(timeout: .seconds(2)) { done in
                        repository.savePopularMovies(movieResponse: moviePage)
                            .sink(receiveCompletion: { completion in
                                if case .failure(let error) = completion {
                                    fail("Should not fail: \(error)")
                                }
                            }, receiveValue: {
                                expect(mockLocal.storedModels).toNot(beEmpty())
                                done()
                            })
                            .store(in: &cancellables)
                    }
                }
            }
        }
    }
}
