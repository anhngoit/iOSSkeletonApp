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

class GetMovieListUseCaseTests: QuickSpec {
    override class func spec() {
        var mockRepository: MockMovieListRepository!
        var useCase: GetMovieListUseCaseImpl!
        var cancellables: Set<AnyCancellable>!

        beforeEach {
            mockRepository = MockMovieListRepository()
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
                    mockRepository.localResult = .success(cached)
                    mockRepository.remoteResult = .success(fresh)
                    
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
                            // Verify savePopularMovies was called with fresh
                            expect(mockRepository.savedMoviePage?.movies.first?.id).to(equal("fresh"))
                            done()
                        }
                    }
                }
            }
            
            context("when local times out, returns fallback then fresh") {
                it("emits fallback then fresh page") {
                    mockRepository.localResult = .failure(AppError.timeout)
                    let fresh = MoviePage(page: 2, totalPages: 2, movies: [Movie.stub(id: "fresh")])
                    mockRepository.remoteResult = .success(fresh)
                    
                    var received: [MoviePage] = []
                    
                    waitUntil(timeout: .seconds(3)) { done in
                        useCase.execute()
                            .sink(receiveCompletion: { _ in },
                                  receiveValue: { received.append($0) })
                            .store(in: &cancellables)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            expect(received.count).to(equal(2))
                            expect(received[0].movies).to(beEmpty()) // fallback page
                            expect(received[1].movies.first?.id).to(equal("fresh"))
                            done()
                        }
                    }
                }
            }
        }
    }
}
