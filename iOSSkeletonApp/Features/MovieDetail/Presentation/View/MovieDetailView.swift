//
//  MovieDetailView.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {

    /// `@ObservedObject`, not `@StateObject`: `MovieDetailScreenCoordinator`
    /// owns the view model and this view is rebuilt from `toPresentable()`.
    @ObservedObject var viewModel: MovieDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                KFImage(viewModel.backdropURL)
                    .placeholder {
                        Rectangle().fill(Color.gray)
                    }
                    .cancelOnDisappear(true)
                    .resizable()
                    .aspectRatio(16 / 9, contentMode: .fit)
                    .cornerRadius(20)

                Text(viewModel.movie.title ?? "Unknown Title")
                    .font(.themeHeading)

                Text(viewModel.releaseDateText)
                    .font(.themeBody)
                    .foregroundColor(.gray)

                if let genresText = viewModel.genresText {
                    Text(genresText)
                        .font(.themeBody)
                        .foregroundColor(.gray)
                }

                Text(viewModel.overviewText)
                    .font(.themeBody)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
        }
        .navigationTitle(viewModel.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
#if DEBUG
#Preview {
    NavigationStack {
        MovieDetailView(viewModel: MovieDetailViewModel(movie: Movie.stub()))
    }
}
#endif
