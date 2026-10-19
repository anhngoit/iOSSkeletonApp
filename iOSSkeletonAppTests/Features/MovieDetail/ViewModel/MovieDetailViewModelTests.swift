//
//  MovieDetailViewModelTests.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import Quick
import Nimble
@testable import iOSSkeletonApp

class MovieDetailViewModelTests: QuickSpec {
    override class func spec() {
        describe("MovieDetailViewModel") {

            context("when the movie has a title") {
                it("uses it as the navigation title") {
                    let viewModel = MovieDetailViewModel(movie: Movie.stub(title: "Borderlands"))

                    expect(viewModel.navigationTitle).to(equal("Borderlands"))
                }
            }

            // `Movie.title` is optional all the way from the DTO, so the detail
            // screen has to render something for a movie the API returned
            // without one.
            context("when the movie has no title") {
                it("falls back to a generic title") {
                    let viewModel = MovieDetailViewModel(movie: Movie(id: "1"))

                    expect(viewModel.navigationTitle).to(equal("Movie"))
                }
            }

            context("when the movie has no genres") {
                it("omits the genre line") {
                    let viewModel = MovieDetailViewModel(movie: Movie(id: "1"))

                    expect(viewModel.genresText).to(beNil())
                }
            }

            context("when the movie has genres") {
                it("joins them for display") {
                    let movie = Movie.stub(genre: [Genre(id: 1, name: "Action"),
                                                   Genre(id: 2, name: "Sci-Fi")])
                    let viewModel = MovieDetailViewModel(movie: movie)

                    expect(viewModel.genresText).to(equal("Action · Sci-Fi"))
                }
            }
        }
    }
}
