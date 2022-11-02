//
//  ViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 31.10.2022.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var viewModel = ViewModelMoviesVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        viewModel.loadTrendingMovies {
            self.moviesCollectionView.reloadData()
        }
        
        viewModel.loadGenresforMovies {
            self.moviesCollectionView.reloadData()
        }
        
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    private func setupUI() {
        moviesCollectionView?.collectionViewLayout = createLayout()
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 8
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(175), heightDimension: .absolute(285))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
//        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }


}

extension MoviesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.arrayOfMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: viewModel.arrayOfMovies[indexPath.row])
        return cell
    }
    
    
}

extension MoviesViewController: UICollectionViewDelegate {
    
}

