//
//  CompositionalLayoutControllerViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 14.11.2022.
//

import UIKit

class CompositionalLayoutControllerViewController: UIViewController {

    let viewModel = ViewModelMoviesVC()
    
    var genres = [Genre]()
    
    private lazy var movieCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.loadGenresforMovies { genres in
            self.genres = genres
            self.movieCollectionView.reloadData()
        }
        
        viewModel.loadUpcomingMovies {
            self.movieCollectionView.reloadData()
        }
        
        viewModel.loadTrendingMovies {
            self.movieCollectionView.reloadData()
        }
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        movieCollectionView.register(TrendingCell.self, forCellWithReuseIdentifier: TrendingCell.identifier)
        
        movieCollectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        
        movieCollectionView.register(Header.self, forSupplementaryViewOfKind: categoryHeaderID, withReuseIdentifier: Header.headerID)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.addSubview(movieCollectionView)
        movieCollectionView.frame = view.bounds
    }
    
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, enviroment) -> NSCollectionLayoutSection? in
            
            if sectionNumber ==  0 {
                return self.movieCollectionView.trendingMovies(headerID: self.categoryHeaderID)
            } else if sectionNumber == 1 {
                return self.movieCollectionView.genres(headerID: self.categoryHeaderID)
            } else {
                return self.movieCollectionView.upcoming(headerID: self.categoryHeaderID)
            }
        }
    }
    
    let categoryHeaderID = "categoryHeaderID"
}

extension CompositionalLayoutControllerViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.headerID, for: indexPath) as! Header
        
        if indexPath.section == 0 {
            header.label.text = "Trending movies"
        } else if indexPath.section == 1 {
            header.label.text = "Genres"
        } else {
            header.label.text = "Upcoming movies"
        }
        
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return viewModel.trending.count
        } else if section == 1 {
            return genres.count
        } else if section == 2 {
            return viewModel.upcoming.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCell.identifier, for: indexPath) as! TrendingCell
            cell.configure(with: viewModel.trending[indexPath.row])
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.identifier, for: indexPath) as! GenreCell
            cell.configure(with: genres[indexPath.row])
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
            cell.configure(with: viewModel.upcoming[indexPath.row])
            return cell
        }
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//
//        if indexPath.section == 1 {
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            guard let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController else { return }
//            vc.configure(genre: movieGenres[indexPath.row])
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
//
//    }
    
}

