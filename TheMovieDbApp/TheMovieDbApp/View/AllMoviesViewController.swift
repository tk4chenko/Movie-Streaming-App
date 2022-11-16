//
//  AllMoviesViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 15.11.2022.
//

import UIKit

class AllMoviesViewController: UIViewController {
    
    static var identifier = "AllMoviesViewController"

    var currentPage = 1
    var totalPages = 3
    var genreId = Int()
    
    let viewModel = ViewModelMoviesVC()
    
    var movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 25, height: (UIScreen.main.bounds.width/2 - 25) * 1.68)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
//        cv.register(UINib(nibName: "MyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MyCollectionViewCell")
        cv.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        return cv
    }()
    
    var arrayOfMovies = [Media]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    public func configure(genre: Genre) {
        title = genre.name
        genreId = genre.id
//        viewModel.loadMovieByGenre(page: 1, genre: genreId) { movies in
//            self.arrayOfMovies = movies
//            self.movieCollectionView.reloadData()
//        }
        viewModel.loadMovieByGenre2(page: 1, genre: genreId) { movies in
            self.arrayOfMovies = movies
            self.movieCollectionView.reloadData()
        }
    }
    
}

extension AllMoviesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if currentPage < totalPages && indexPath.row == arrayOfMovies.count - 1 {
            currentPage += 1
            viewModel.loadMovieByGenre2(page: currentPage, genre: genreId) { movies in
                self.arrayOfMovies.append(contentsOf: movies)
                    collectionView.reloadData()
                }
            }
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(color: .red, with: arrayOfMovies[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailsViewController()
        vc.configure(mediaType: "movie", media: arrayOfMovies[indexPath.row], genres: viewModel.arrayOfMovieGenres)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
