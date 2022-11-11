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

        viewModel.loadTvByGenre {
            self.moviesCollectionView.reloadData()
        }
        
        viewModel.loadMovieByGenre {
            self.moviesCollectionView.reloadData()
        }

        moviesCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier)
        moviesCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)

    }
    
    private func setupUI() {
        moviesCollectionView?.collectionViewLayout = createLayout()
        moviesCollectionView.delegate = self
        moviesCollectionView.dataSource = self
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(signOut))
    }
    
    @objc func signOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AuthenticationViewController")
        vc.modalPresentationStyle = .fullScreen
//                        self.dismiss(animated: true)
        self.present(vc, animated: false)
        sessionId = ""
//        viewModel.deleteSession(sessionId: sessionId)
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(185), heightDimension: .absolute(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(50.0))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: UICollectionView.elementKindSectionHeader,
                                                                 alignment: .top)
        let section = NSCollectionLayoutSection(group: group)
        section.boundarySupplementaryItems = [header]
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

}

extension MoviesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.identifier, for: indexPath) as! SectionHeader
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
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as? MovieCollectionViewCell else { return UICollectionViewCell() }
        
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = DetailsViewController()
        
        switch segmentController.selectedSegmentIndex {
        case 0:
            let key = Array(viewModel.dictOfMovies.keys).sorted(by: <)[indexPath.section]
            let value = viewModel.dictOfMovies[key]![indexPath.row]
            vc.configure(mediaType: "movie", media: value, genres: viewModel.arrayOfMovieGenres)
        case 1:
            let key = Array(viewModel.dictOfTVShows.keys).sorted(by: <)[indexPath.section]
            let value = viewModel.dictOfTVShows[key]![indexPath.row]
            vc.configure(mediaType: "tv", media: value, genres: viewModel.arrayOfTVGenres)
        default:
            print("no controller")
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

