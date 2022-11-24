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
    
    private var searchBar: UISearchController = {
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
        
        viewModel.loadGenres()
        
//        searchBar.searchBar.delegate = self
        navigationItem.title  = "Search"
        view.backgroundColor = .systemBackground
        searchBar.searchResultsUpdater = self
        navigationItem.searchController = searchBar
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
        viewModel.currentPage = 1
        viewModel.searchMovie(query: query) {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let query = searchBar.searchBar.text else { return }
        if viewModel.currentPage < viewModel.totalPages && indexPath.row == movies.count - 1 {
            viewModel.searchMovie(query: query.trimmingCharacters(in: .whitespaces)) {
                DispatchQueue.main.async {
                    self.movieCollectionView.reloadData()
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.searched.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell {
            cell.configure(color: .systemBlue, with: viewModel.searched[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
        vc.configure(mediaType: "movie", media: viewModel.searched[indexPath.row], genres: viewModel.genres)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
// doesn't work
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searched.removeAll()
        searchBar.text = ""
        movieCollectionView.reloadData()
    }
}

