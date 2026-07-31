//
//  MovieListView.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
//

import SwiftUI

struct MovieListView: View {

    @StateObject var viewModel = MovieListViewModel()

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Array(viewModel.movies.enumerated()), id: \.element.id) { index, movie in
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
                viewModel.onAppear()
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                } else if viewModel.isEmpty {
                    ContentUnavailableView(
                        "No movies",
                        systemImage: "film",
                        description: Text("Pull to refresh once you're back online.")
                    )
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

        /// Must be stable: SwiftUI diffs presented items by `id`, and returning
        /// a fresh UUID on every read made the alert re-present itself.
        var id: String {
            switch self {
            case .error(let message): return "error-\(message)"
            case .success(let message): return "success-\(message)"
            }
        }
    }
}

// MARK: - Preview
#if DEBUG
/// Preview-only view model. Kept behind `#if DEBUG` so it never ships.
final class MockMovieListViewModel: MovieListViewModel {
    init(movies: [Movie]) {
        super.init()
        self.movies = movies
    }

    /// Previews must not hit the network.
    override func onAppear() {}
}

#Preview {
    MovieListView(viewModel: MockMovieListViewModel(movies: [Movie.stub()]))
}
#endif
