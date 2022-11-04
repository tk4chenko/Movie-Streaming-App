//
//  ViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 31.10.2022.
//

import UIKit

class MoviesViewController: UIViewController {

    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var viewModel = ViewModelMoviesVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
//        viewModel.loadGenresforMovies { genre in 
//            self.moviesCollectionView.reloadData()
//        }
        
        viewModel.loadTvByGenre {
            self.moviesCollectionView.reloadData()
        }
        
        viewModel.loadMovieByGenre {
            self.moviesCollectionView.reloadData()
        }

        moviesCollectionView.register(UINib(nibName: "SectionHeader", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        
        moviesCollectionView.register(UINib(nibName: "MovieCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MovieCollectionViewCell")
    }
    
    private func setupUI() {
        moviesCollectionView?.collectionViewLayout = createLayout()
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
    }
    
    @IBAction func pressedSegment(_ sender: Any) {
        moviesCollectionView.reloadData()
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
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuous
//        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 4, trailing: 8)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }


}

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
        switch segmentController.selectedSegmentIndex {
        case 0:
            header.nameLabel.text = Array(self.viewModel.dictOfMovies.keys).sorted(by: <)[indexPath.section]
        case 1:
            header.nameLabel.text = Array(self.viewModel.dictOfTVShows.keys).sorted(by: <)[indexPath.section]
        default:
            return UICollectionReusableView()
        }
        return header
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch segmentController.selectedSegmentIndex {
        case 0: return self.viewModel.dictOfMovies.keys.count
        case 1: return self.viewModel.dictOfTVShows.keys.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch segmentController.selectedSegmentIndex {
        case 0: return self.viewModel.dictOfMovies.values.count
        case 1: return self.viewModel.dictOfTVShows.values.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            let key = Array(viewModel.dictOfMovies.keys).sorted(by: <)[indexPath.section]
            let value = viewModel.dictOfMovies[key]![indexPath.row]
            cell.configure(with: value)
        case 1:
            let key = Array(viewModel.dictOfTVShows.keys).sorted(by: <)[indexPath.section]
            let value = viewModel.dictOfTVShows[key]![indexPath.row]
            cell.configure(with: value)
        default:
            return UICollectionViewCell()
        }
        return cell
    }
    
}

extension MoviesViewController: UICollectionViewDelegate {
    
}

