//
//  MovieListViewModel2.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 06/05/2024.
//

import Foundation
import Combine

@MainActor
class MovieListViewModel2: ObservableObject {
    
    // MARK: Private Properties
    private let movieListUseCase: MovieListUseCase2

    private var cancellables = Set<AnyCancellable>()

    private var currentPage: Int = 1
    private var totalPageCount: Int = 1
    private var nextPage: Int { hasMorePages ? currentPage + 1 : currentPage }

    // MARK: - OUTPUT
    @Published var movies: [Movie] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var error: String?
    @Published private(set) var isEmpty: Bool = false

    let screenTitle: String = ""
    let emptyDataTitle: String = ""
    let errorTitle: String = "Error"
    let searchBarPlaceholder: String = ""

    var hasMorePages: Bool { currentPage < totalPageCount }
    
    var showMovieDetail: ((_ id: String) -> Void)?

    // MARK: Init
    init(movieListUseCase: MovieListUseCase2) {
        self.movieListUseCase = movieListUseCase
    }
    
    // MARK: Private Methods
    private func fetchMovies(currentPage: Int) async {
        guard !isLoading else { return }
        isLoading = true
        do {
            try await movieListUseCase.getPopularMovies(page: currentPage, cached: { [weak self] movieResponse in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if let movieResponse = movieResponse {
                        self.currentPage = movieResponse.page
                        self.totalPageCount = movieResponse.totalPages
                        self.movies.append(contentsOf: movieResponse.movies)
                    }
                    self.isLoading = false
                }
            }, completion: { [weak self] movieResponse in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.currentPage = movieResponse.page
                    self.totalPageCount = movieResponse.totalPages
                    let toIndex = movieResponse.page*20-1
                    let fromIndex = toIndex - 20 + 1
                    if self.movies.count > fromIndex {
                        self.movies.removeSubrange(fromIndex...toIndex)
                    }
                    self.movies.append(contentsOf: movieResponse.movies)
                }
            })
            DispatchQueue.main.async {
                self.isEmpty = self.movies.isEmpty
            }
        } catch {
            DispatchQueue.main.async {
                self.error = error.localizedDescription
            }
        }
    }
}

extension MovieListViewModel2 {

    // MARK: Life Cycle
    func onAppear() async {
        await fetchMovies(currentPage: 1)
    }
    
    // MARK: Actions
    func loadNextPage() async {
        guard hasMorePages, !isLoading else { return }
        currentPage += 1
        await fetchMovies(currentPage: currentPage)
    }
    
    func didSearch(query: String) {
        
    }
    
    func didSelectItem(at index: Int) {
        showMovieDetail?(movies[index].id)
    }
}
