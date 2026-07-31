//
//  MovieListViewModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import Foundation
import Combine
import Factory

@MainActor
class MovieListViewModel: BaseViewModel {

    // MARK: Use cases
    @Injected(\.movieListUseCase) private var movieListUseCase

    // MARK: Private Properties
    private var hasLoaded = false

    // MARK: - Output
    @Published var movies: [Movie] = []
    @Published var activeAlert: MovieListView.AlertType?
    @Published var isEmpty: Bool = false

    // MARK: - Localized
    let navigationTitle = "Movies"

    // MARK: Life Cycle
    func onAppear() {
        guard !hasLoaded else { return }
        hasLoaded = true
        fetchMovies()
    }

    // MARK: Private Methods
    private func fetchMovies() {
        isLoading = true
        movieListUseCase.execute()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.activeAlert = .error(error.localizedDescription)
                }
            } receiveValue: { [weak self] movieResponse in
                guard let self = self else { return }
                self.movies = movieResponse.movies
                self.isEmpty = movieResponse.movies.isEmpty
            }
            .store(in: &cancellables)
    }
}

extension MovieListViewModel {

    // MARK: Actions
    func didSelectItem(at index: Int) {

    }
}
