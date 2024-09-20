//
//  MovieDetailViewController.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 15/05/2024.
//

import UIKit
import Moya
import RxSwift
import Kingfisher

class MovieDetailViewController: UIViewController {

    var viewModel: MovieDetailViewModel = DIContainer.shared.movieDetailViewModel

    var movieId = ""
    
    @IBOutlet private weak var imgBackground: UIImageView!
    @IBOutlet private weak var imgFront: UIImageView!
    @IBOutlet private weak var lblTitle: UILabel!
    @IBOutlet private weak var lblVote: UILabel!
    @IBOutlet private weak var lblGenre: UILabel!
    @IBOutlet private weak var lblReleasedDate: UILabel!
    @IBOutlet private weak var lblOverview: UILabel!
    @IBOutlet private weak var blurView: UIView!

    private let disposeBag = DisposeBag()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewModel.movieId = movieId
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    private func bindViewModel() {
        disposeBag.insert([
            viewModel
                .item
                .subscribe(onNext: { [weak self] movie in
                    guard let self = self else { return }
                    self.loadUI(movie: movie)
                })
        ])
    }
    
    private func loadUI(movie: Movie) {
        if let posterPath = movie.posterPath, let url = URL(string: Environment.photoEndpointUrl + posterPath) {
            imgFront.kf.setImage(with: KF.ImageResource(downloadURL: url))
        }
        if let backdropPath = movie.backdropPath, let url = URL(string: Environment.photoEndpointUrl + backdropPath) {
            imgBackground.kf.setImage(with: KF.ImageResource(downloadURL: url))
        }
        lblTitle.text = movie.title
        lblGenre.text = movie.genres.map { $0.name }.joined(separator: ", ")
        lblReleasedDate.text = movie.releaseDate?.toString()
        lblOverview.text = movie.overview
        blurView.backgroundColor = .black
        blurView.alpha = 0.3
    }
}
