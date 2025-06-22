//
//  MovieItem.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 18/6/25.
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
            Text(movie.title ?? "Unknown Title")
                .font(.themeTitle)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
            Text(movie.releaseDate?.toString() ?? "Unknown Date")
                .font(.themeBody)
                .foregroundColor(.gray)
                .padding(.horizontal)
                .padding(.bottom)

        }
        .background(.lightPurple)
        .cornerRadius(20)
    }
}

#Preview {
    MovieItem(movie: Movie.stub())
}
