//
//  MovieCollectionViewCell.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 24/06/2024.
//

import UIKit
import Kingfisher

final class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var imgMovie: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblReleasedDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(with movie :Movie) {
        if let posterPath = movie.posterPath, let url = URL(string: Environment.photoEndpointUrl + posterPath) {
            imgMovie.kf.setImage(with: KF.ImageResource(downloadURL: url))
        }
        lblTitle.text = movie.title
        lblReleasedDate.text = movie.releaseDate?.toString()
    }
}
