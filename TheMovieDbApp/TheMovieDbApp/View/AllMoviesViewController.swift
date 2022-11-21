//
//  AllMoviesViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 15.11.2022.
//

import UIKit

class AllMoviesViewController: UIViewController {
    
    static var identifier = "AllMoviesViewController"
    
    private var genreId = Int()
    private var mediaType = String()
    
    private let viewModel = ViewModelAllMoviesVC()
    
    var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 25, height: (UIScreen.main.bounds.width/2 - 25) * 1.68)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchGenres(type: mediaType) {
            self.movieCollectionView.reloadData()
        }
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        setupConstraint()
    }
    
    private func setupConstraint() {
        view.addSubview(movieCollectionView)
        NSLayoutConstraint.activate([
            movieCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            movieCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15),
            movieCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    public func configure(type: String, genre: Genre) {
        mediaType = type
        title = genre.name
        genreId = genre.id
        
        viewModel.fetchMedia(type: mediaType, genre: genreId) {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }
    
}

extension AllMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if viewModel.currentPage < viewModel.totalPages && indexPath.row == viewModel.arrayOfMediaByGenre.count - 1 {
            viewModel.fetchMedia(type: mediaType, genre: genreId) {
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.arrayOfMediaByGenre.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(color: .red, with: viewModel.arrayOfMediaByGenre[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.configure(mediaType: mediaType, media: viewModel.arrayOfMediaByGenre[indexPath.row], genres: viewModel.genres)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
