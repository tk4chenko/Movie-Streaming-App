//
//  SearchViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 05.11.2022.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movies = [Media]()
    
    var viewModel = ViewModelSeacrVC()
    var genres = [Genre]()
    
    private var searchController: UISearchController = {
        let sc = UISearchController()
        sc.searchBar.searchBarStyle = .minimal
//        sc.searchBar.showsScopeBar = true
//        sc.searchBar.scopeButtonTitles = ["Movies", "TVShows"]
        sc.searchBar.placeholder = "Enter the movie name"
        return sc
    }()
    
    private var movieCollectionView: UICollectionView = {
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
        
        viewModel.fetchPopularMovies {
            self.movieCollectionView.reloadData()
        }
        
        navigationItem.backButtonTitle = ""
        navigationItem.title  = "Search"
        view.backgroundColor = .systemBackground
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
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
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let query = searchController.searchBar.text else { return }
        
        if query.isEmpty {
            viewModel.searched.removeAll()
            movieCollectionView.reloadData()
        }
        
        self.viewModel.currentPage = 0
        viewModel.searchMovie(query: query.trimmingCharacters(in: .whitespaces)) {
                self.movieCollectionView.reloadData()
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let query = searchController.searchBar.text else { return }
        if viewModel.currentPage < viewModel.totalPages && indexPath.row == viewModel.searched.count - 1 {
            viewModel.searchMovie(query: query.trimmingCharacters(in: .whitespaces)) {
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch searchController.isActive {
        case true:
            return viewModel.searched.count
        case false:
            return viewModel.popular.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.headerID, for: indexPath) as! Header
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        switch searchController.isActive {
        case true:
            cell.configure(color: .red, with: viewModel.searched[indexPath.row])
            return cell
        case false:
            cell.configure(color: .red, with: viewModel.popular[indexPath.row])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        vc.configure(mediaType: "movie", media: viewModel.searched[indexPath.row])
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

