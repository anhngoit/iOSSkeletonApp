//
//  MovieListView.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftUI
import Moya

struct MovieListView: View {
    
    @StateObject var viewModel: MovieListViewModel

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
                    }
                }
                .padding()
            }
            .navigationTitle(viewModel.navigationTitle)
            .task {
                viewModel.viewDidAppear()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                } else {
                    EmptyView()
                }
            }
            .alert(item: $viewModel.activeAlert) { alertType in
                switch alertType {
                case .error(let message):
                    return Alert(
                        title: Text("Error"),
                        message: Text(message),
                        dismissButton: .default(Text("OK"))
                    )
                    
                case .success(let message):
                    return Alert(
                        title: Text("Success"),
                        message: Text(message),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
    
    private func handleMovieSelection(at index: Int) {
        viewModel.didSelectItem(at: index)
    }

}

// MARK: - Alert
extension MovieListView {
    enum AlertType: Identifiable {
        case error(String)
        case success(String)

        var id: String { UUID().uuidString }
    }
}

// MARK: - Preview
/// Mock ViewModel for Preview
class MockMovieListViewModel: MovieListViewModel {
  override init() {
      super.init()
      self.movies = [Movie.stub()]
  }
}

#Preview {
    let mockViewModel = MockMovieListViewModel()
    return MovieListView(viewModel: mockViewModel)
}
