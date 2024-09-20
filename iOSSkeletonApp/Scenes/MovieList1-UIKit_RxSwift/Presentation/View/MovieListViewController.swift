//
//  MovieListViewController.swift
//  iOSSkeletonApp
//
//  Created by Anh “Steven” Ngo on 15/05/2024.
//

import UIKit
import Moya
import RxSwift

class MovieListViewController: UIViewController {

    // MARK: - Constants
    struct Constants {
        static let minInteritemSpacing: CGFloat = 5
        static let sectionInset: CGFloat = 5
    }

    var viewModel: MovieListViewModel = DIContainer.shared.movieListViewModel

    private let disposeBag = DisposeBag()
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupCollectionView()
        bindViewModel()
        viewModel.viewDidLoad()

        checkAccessTokenAuthen()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib.init(nibName: R.nib.movieCollectionViewCell.name, bundle: nil),
                                forCellWithReuseIdentifier: R.reuseIdentifier.movieCollectionViewCell.identifier)
    }
    
    private func bindViewModel() {
        disposeBag.insert([
            viewModel
                .items
                .subscribe(onNext: { [weak self] movies in
                    guard let self = self else { return }
                    self.collectionView.reloadData()
                })
        ])
    }

    private func checkAccessTokenAuthen() {
        if Environment.accessTokenAuthen == "" {
            let alert = UIAlertController(
                title: "Access Token Authentication Missing",
                message: "You haven't set up Access Token Authentication. Please go through README.md for more information.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            // Present the alert on the current view controller
            self.present(alert, animated: true, completion: nil)
        }
    }
}

extension MovieListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.movieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.config(with: viewModel.items.value[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectItem(at: indexPath.row)
    }
}

extension MovieListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/2-Constants.minInteritemSpacing

        return CGSize(width: width, height: width*1.8)
    }
}
