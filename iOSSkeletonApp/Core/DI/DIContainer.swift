//
//  DIContainer.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 6/9/24.
//

import Foundation
import Moya

class DIContainer {
    static let shared = DIContainer()

    var movieListViewModel: MovieListViewModel
    var movieDetailViewModel: MovieDetailViewModel

    var movieListUseCase: MovieListUseCase
    var movieListUseCase2: MovieListUseCase2
    var movieDetailUseCase: MovieDetailUseCase

    var movieListRepository: MovieListRepository
    var movieListRepository2: MovieListRepository2
    var movieDetailRepository: MovieDetailRepository

    var movieApiDataSource: MoyaProvider<MovieAPI>
    var movieLocalDataSource: RealmDataSource<MovieResponseRModel>
    var movieDetailLocalDataSource: RealmDataSource<MovieRModel>

    init() {
        movieApiDataSource = MoyaProvider<MovieAPI>()
        movieLocalDataSource = RealmDataSource<MovieResponseRModel>()
        movieDetailLocalDataSource = RealmDataSource<MovieRModel>()

        movieListRepository = MovieListRepositoryImpl(movieApiDataSource: movieApiDataSource, movieLocalDataSource: movieLocalDataSource)
        movieListRepository2 = MovieListRepositoryImpl2(movieApiDataSource: movieApiDataSource, movieLocalDataSource: movieLocalDataSource)
        movieDetailRepository = MovieDetailRepositoryImpl(movieApiDataSource: movieApiDataSource, movieDetailLocalDataSource: movieDetailLocalDataSource)

        movieListUseCase = MovieListUseCaseImpl(movieListRepository: movieListRepository)
        movieListUseCase2 = MovieListUseCaseImpl2(movieListRepository: movieListRepository2)
        movieDetailUseCase = MovieDetailUseCaseImpl(movieDetailRepository: movieDetailRepository)

        movieListViewModel = MovieListViewModelImpl(movieListUseCase: movieListUseCase)
        movieDetailViewModel = MovieDetailViewModel(movieDetailUseCase: movieDetailUseCase)
    }
}
