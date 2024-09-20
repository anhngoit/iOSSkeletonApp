//
//  MovieDetailViewModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol MoviesDetailViewModelInput {
    var movieId: String { get set }
    
    func viewDidLoad()
}

protocol MoviesDetailViewModelOutput {
    var item: BehaviorRelay<Movie> { get }
    var loading: BehaviorRelay<Bool> { get }
    var error: PublishRelay<String> { get }
    var isEmpty: PublishRelay<Bool> { get }
        
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
}

typealias MoviesDetailViewModelContract = MoviesDetailViewModelInput & MoviesDetailViewModelOutput

class MovieDetailViewModel: MoviesDetailViewModelContract {
    
    private let movieDetailUseCase: MovieDetailUseCase
    
    // MARK: - INPUT
    var movieId: String = ""
    
    // MARK: - OUTPUT
    var item = BehaviorRelay<Movie>(value: Movie(id: ""))
    var loading = BehaviorRelay<Bool>(value: false)
    var error = PublishRelay<String>()
    var isEmpty = PublishRelay<Bool>()
    var screenTitle: String = ""
    var emptyDataTitle: String = ""
    var errorTitle: String = ""
    
    init(movieDetailUseCase: MovieDetailUseCase) {
        self.movieDetailUseCase = movieDetailUseCase
    }
    
    private func getMovieDetail(id: String) {
        movieDetailUseCase.getMovieDetail(id: id, cached: { [weak self] movie in
            guard let self = self, let movie = movie else { return }
            self.item.accept(movie)
        }, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movie):
                self.item.accept(movie)
            case .failure(let error): 
                self.error.accept(error.localizedDescription)
            }
        })
    }
}

extension MovieDetailViewModel {
    func viewDidLoad() {
        getMovieDetail(id: movieId)
    }
}
