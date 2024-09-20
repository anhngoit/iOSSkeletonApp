//
//  MovieListView.swift
//  iOSSkeletonApp
//
//  Created by anh.ngo on 11/9/24.
//

import SwiftUI
import Moya

struct MovieListView: View {
    
    @StateObject var viewModel: MovieListViewModel2

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.movies.indices, id: \.self) { index in
                        let movie = viewModel.movies[index]
                        MovieItem(movie: movie)
                            .onTapGesture {
                                handleMovieSelection(at: index)
                            }
                            .onAppear {
                                //loadMoreMoviesIfNeeded(currentIndex: index)
                            }
                    }
                    
                    if viewModel.isLoading && viewModel.hasMorePages {
                        ProgressView("Loading more movies...")
                            .frame(maxWidth: .infinity)
                    }
                }
                .padding()
            }
            .navigationTitle("Movies")
            .task {
                await viewModel.onAppear()
            }
            .overlay {
                if viewModel.isLoading && viewModel.movies.isEmpty {
                    ProgressView("Loading...")
                } else {
                    EmptyView()
                }
            }
            .alert(isPresented: .constant(viewModel.error != nil)) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorTitle),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // Separate method for handling movie selection
    private func handleMovieSelection(at index: Int) {
        viewModel.didSelectItem(at: index)
    }

    // Separate method for loading more movies when scrolling
    private func loadMoreMoviesIfNeeded(currentIndex: Int) async {
        if currentIndex == viewModel.movies.count - 1 {
            await viewModel.loadNextPage()
        }
    }
}


#Preview {
    let mockViewModel = MockMovieListViewModel(movieListUseCase: DIContainer.shared.movieListUseCase2)
    return MovieListView(viewModel: mockViewModel)
}

// Mock ViewModel for Preview
class MockMovieListViewModel: MovieListViewModel2 {
  override init(movieListUseCase: MovieListUseCase2) {
      super.init(movieListUseCase: movieListUseCase)
      self.movies = [Movie.stub()]
  }
}

