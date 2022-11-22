//
//  CompositionalLayoutControllerViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 14.11.2022.
//

import UIKit

class DiscoverViewController: UIViewController {
    
    private let viewModel = ViewModelMoviesVC()
    
    private var selectedItem: String! {
        if segmentController.selectedSegmentIndex == 0 {
            return "movie"
        } else {
            return "tv"
        }
    }
    
    private lazy var movieCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let segmentController: UISegmentedControl = {
        let items = ["Movies", "TVShows"]
        let control = UISegmentedControl(items: items)
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = 0
        return control
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Discover"
        
        segmentController.setupSegment()
        
        segmentController.addTarget(self, action: #selector(segmentTapped), for: .valueChanged)
        
        fetchData(type: selectedItem)
        
        movieCollectionView.delegate = self
        movieCollectionView.dataSource = self
        
        movieCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        
        movieCollectionView.register(TrendingCell.self, forCellWithReuseIdentifier: TrendingCell.identifier)
        
        movieCollectionView.register(GenreCell.self, forCellWithReuseIdentifier: GenreCell.identifier)
        
        movieCollectionView.register(Header.self, forSupplementaryViewOfKind: categoryHeaderID, withReuseIdentifier: Header.headerID)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
    }
    
    @objc func signOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
        viewModel.delSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }
    
    @objc func segmentTapped() {
        self.segmentController.setupSegment()
        self.movieCollectionView.reloadData()
        fetchData(type: selectedItem)
    }
    
    private func fetchData(type: String) {
        
        viewModel.fetchGenres(type: type) {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }

        viewModel.fetchTrending(type: type) {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }

        viewModel.fetchUpcoming(type: type) {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }

        viewModel.fetchTopRated(type: type) {
            DispatchQueue.main.async {
                self.movieCollectionView.reloadData()
            }
        }
    }
    
    private func setupConstraints() {
        view.addSubview(movieCollectionView)
        view.addSubview(segmentController)
        
        NSLayoutConstraint.activate([
            segmentController.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            segmentController.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            segmentController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            movieCollectionView.topAnchor.constraint(equalTo: segmentController.bottomAnchor, constant: 0),
            movieCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            movieCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            movieCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (sectionNumber, enviroment) -> NSCollectionLayoutSection? in
            
            if sectionNumber ==  0 {
                return self.movieCollectionView.genres(headerID: self.categoryHeaderID)
            } else if sectionNumber == 1 {
                return self.movieCollectionView.trendingMovies(headerID: self.categoryHeaderID)
            } else if sectionNumber == 2 {
                return self.movieCollectionView.upcoming(headerID: self.categoryHeaderID)
            } else {
                return self.movieCollectionView.upcoming(headerID: self.categoryHeaderID)
            }
        }
    }
    private let categoryHeaderID = "categoryHeaderID"
}

extension DiscoverViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Header.headerID, for: indexPath) as! Header
        
        let mediaType: String = {
            if self.segmentController.selectedSegmentIndex == 0 {
                return "Movies"
            } else {
                return "TVShows"
            }
        }()
        
        if indexPath.section == 0 {
            header.label.text = "Genres"
            header.label.textColor = .red
        } else if indexPath.section == 1 {
            header.label.text = "Trending \(mediaType)"
            header.label.textColor = .systemPink
            
            
        } else if indexPath.section ==  2{
            header.label.text = "Popular \(mediaType)"
            header.label.textColor = .systemBlue
            
        } else {
            header.label.text = "Top Rated \(mediaType)"
            header.label.textColor = .systemOrange
        }
        
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return viewModel.genres.count
        } else if section == 1 {
            return viewModel.trending.count
        } else if section == 2 {
            return viewModel.upcoming.count
        } else if section == 3 {
            return viewModel.topRated.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCell.identifier, for: indexPath) as! GenreCell
            cell.configure(with: viewModel.genres[indexPath.row])
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrendingCell.identifier, for: indexPath) as! TrendingCell
            cell.configure(with: viewModel.trending[indexPath.row])
            return cell
        } else if indexPath.section == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
            cell.configure(color: .systemBlue, with: viewModel.upcoming[indexPath.row])
            return cell
        } else if indexPath.section == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
            cell.configure(color: .systemOrange, with: viewModel.topRated[indexPath.row])
            return cell
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: AllMoviesViewController.identifier) as? AllMoviesViewController else { return }
            vc.configure(type: selectedItem, genre: viewModel.genres[indexPath.row])
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 1 {
            let vc = DetailsViewController()
            vc.configure(mediaType: selectedItem, media: viewModel.trending[indexPath.row], genres: viewModel.genres)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            let vc = DetailsViewController()
            vc.configure(mediaType: selectedItem, media: viewModel.upcoming[indexPath.row], genres: viewModel.genres)
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 3 {
            let vc = DetailsViewController()
            vc.configure(mediaType: selectedItem, media: viewModel.topRated[indexPath.row], genres: viewModel.genres)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
//
//extension DiscoverViewController: UpdateView {
//    func reloadData() {
//        DispatchQueue.main.async {
//            self.movieCollectionView.reloadData()
//        }
//    }
//}
