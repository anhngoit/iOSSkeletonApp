//
//  MovieItem.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 11/9/24.
//

import SwiftUI
import Kingfisher

struct MovieItem: View {
    let movie: Movie

    var body: some View {
        VStack {
            KFImage(URL(string: Environment.photoEndpointUrl + (movie.posterPath ?? "")))
            .placeholder {
                // Placeholder while loading image
                Rectangle().fill(Color.gray)
            }
            .cancelOnDisappear(true) // Cancels loading if view disappears
            .resizable()
            .aspectRatio(0.7, contentMode: .fit)
            .clipped()
            Text(movie.title ?? "Unknown Title")
                .font(.headline)
            Text(movie.releaseDate?.toString() ?? "Unknown Date")
                .font(.subheadline)
                .foregroundColor(.gray)
        }
        .cornerRadius(20)
        .shadow(radius: 4)
    }
}

#Preview {
    MovieItem(movie: Movie.stub())
}
