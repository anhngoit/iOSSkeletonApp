//
//  MovieListViewModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation
import RxSwift
import RxCocoa

protocol MovieListViewModelInput {
    func viewDidLoad()
    func didLoadNextPage()
    func didSearch(query: String)
    func didSelectItem(at index: Int)
}

protocol MovieListViewModelOutput {
    var items: BehaviorRelay<[Movie]> { get }
    var loading: BehaviorRelay<Bool> { get }
    var error: PublishRelay<String> { get }
    var isEmpty: PublishRelay<Bool> { get }
        
    var screenTitle: String { get }
    var emptyDataTitle: String { get }
    var errorTitle: String { get }
    var searchBarPlaceholder: String { get }

    var navigateToMovieDetail: ((_ movieId: String) -> Void)? { get set }
}

typealias MovieListViewModel = MovieListViewModelInput & MovieListViewModelOutput

class MovieListViewModelImpl: MovieListViewModel {

    // MARK: - Constants
    struct Constants {
        static let numberItemInPage = 20
    }

    // MARK: Private Properties
    private let movieListUseCase: MovieListUseCase
    
    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    private var hasMorePages: Bool { currentPage < totalPageCount }
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }
    
    // MARK: - OUTPUT
    var items = BehaviorRelay<[Movie]>(value: [])
    var loading = BehaviorRelay<Bool>(value: false)
    var error = PublishRelay<String>()
    var isEmpty = PublishRelay<Bool>()
    var screenTitle: String = ""
    var emptyDataTitle: String = ""
    var errorTitle: String = ""
    var searchBarPlaceholder: String = ""

    var navigateToMovieDetail: ((_ movieId: String) -> Void)?

    init(movieListUseCase: MovieListUseCase ) {
        self.movieListUseCase = movieListUseCase
    }

    private func getMovies(currentPage: Int) {
        guard !loading.value else { return }
        loading.accept(true)
        movieListUseCase.getPopularMovies(page: currentPage, cached: { [weak self] movieResponse in
            guard let self = self else { return }
            if let movieResponse = movieResponse {
                self.currentPage = movieResponse.page
                self.totalPageCount = movieResponse.totalPages
                var items = items.value
                items.append(contentsOf: movieResponse.movies)
                self.items.accept(items)
            }
            loading.accept(false)

        }, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let movieResponse):
                self.currentPage = movieResponse.page
                self.totalPageCount = movieResponse.totalPages
                var items = items.value
                let toIndex = movieResponse.page*Constants.numberItemInPage-1
                let fromIndex = toIndex - Constants.numberItemInPage + 1
                if items.count > fromIndex {
                    items.removeSubrange(fromIndex...toIndex)
                    items.append(contentsOf: movieResponse.movies)
                }
                items.append(contentsOf: movieResponse.movies)
                self.items.accept(items)
                self.isEmpty.accept(self.items.value.isEmpty)
            case .failure(let error):
                self.error.accept(error.localizedDescription)
            }
        })
    }
}

// MARK: - INPUT
extension MovieListViewModelImpl {
    func viewDidLoad() {
        getMovies(currentPage: 1)
    }
    
    func didLoadNextPage() {
        guard hasMorePages, loading.value == false else { return }
        currentPage += 1
        getMovies(currentPage: currentPage)
    }
    
    func didSearch(query: String) {
        
    }

    func didSelectItem(at index: Int) {
        let movieId = String(items.value[index].id)
        navigateToMovieDetail?(movieId)
    }
}
