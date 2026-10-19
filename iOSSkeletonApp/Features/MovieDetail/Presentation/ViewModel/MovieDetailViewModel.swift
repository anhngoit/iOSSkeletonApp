//
//  MovieDetailViewModel.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/8/26.
//

import Foundation

/// Presentational only — renders the `Movie` the list already loaded. There is
/// deliberately no use case, repository or request here; the detail screen
/// exists to demonstrate the push half of the coordinator pattern.
@MainActor
final class MovieDetailViewModel: BaseViewModel {

    // MARK: - Output
    let movie: Movie

    // MARK: - Localized
    var navigationTitle: String { movie.title ?? "Movie" }

    /// Joins the configured image host with the backdrop path without doubling
    /// the separator — the endpoint ends in `/` and TMDB paths start with one.
    var backdropURL: URL? {
        guard let path = movie.backdropPath ?? movie.posterPath, !path.isEmpty else { return nil }
        let base = Environment.photoEndpointUrl
        let suffix = path.hasPrefix("/") ? String(path.dropFirst()) : path
        return URL(string: base.hasSuffix("/") ? base + suffix : base + "/" + suffix)
    }

    var releaseDateText: String { movie.releaseDate?.toString() ?? "Unknown Date" }

    var genresText: String? {
        guard !movie.genres.isEmpty else { return nil }
        return movie.genres.map(\.name).joined(separator: " · ")
    }

    var overviewText: String { movie.overview ?? "No overview available." }

    // MARK: Life Cycle
    init(movie: Movie) {
        self.movie = movie
        super.init()
    }
}
