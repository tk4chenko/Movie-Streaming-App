//
//  DetailsViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 04.11.2022.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper

class DetailsViewController: UIViewController {
    
    private let viewModel = ViewModelDetailsVC()
    
    static var identifier = "DetailsViewController"
    
    private var mediaId = Int()
    private var mediaType = String()
    private var watchlistType = String()
//    private var genres = [Genre]()
    
    private lazy var pageControl: UIPageControl = {
        let control = UIPageControl()
        control.translatesAutoresizingMaskIntoConstraints = false
        control.isUserInteractionEnabled = true
        control.currentPageIndicatorTintColor = .red
        control.pageIndicatorTintColor = .systemGray5
        return control
    }()
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 7
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let scoreView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private lazy var videoCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        view.backgroundColor = .white
        
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getWatchlist(type: watchlistType) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(self.addTapped))
            
            for movie in self.viewModel.watchlist {
                if movie.id == self.mediaId {
                    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"), style: .plain, target: self, action: #selector(self.removeTapped))
                    return
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraint()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var layout = UICollectionViewLayout()
        let spacing: CGFloat = 0
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(view.frame.size.width / 1.77))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .paging
        layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    @objc func addTapped() {
        viewModel.addToWatchlist(watchlist: true, mediaType: mediaType, mediaId: mediaId) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star.fill"))
        }
    }
    
    @objc func removeTapped() {
        viewModel.addToWatchlist(watchlist: false, mediaType: mediaType, mediaId: mediaId) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"))
        }
    }
    
    public func configure(mediaType: String, media: Media) {
        mediaId = media.id
    
        func choosingGenres(genres: [Genre]) -> String {
            var g = ""
            for id in media.genre_ids {
                for genre in genres {
                    if id == genre.id {
                        if id == media.genre_ids.last {
                            g += genre.name
                        } else {
                            g += genre.name + ", "
                        }
                    }
                }
            }
            return g
        }
        
        if media.title != nil {
            self.mediaType = "movie"
            self.watchlistType = "movies"
            viewModel.fetchMovieGenres { genres in
                self.genreLabel.text = choosingGenres(genres: genres)
            }
        } else {
            self.mediaType = "tv"
            self.watchlistType = "tv"
            viewModel.fetchTVGenres { genres in
                self.genreLabel.text = choosingGenres(genres: genres)
            }
        }
    
        title = media.title ?? "" + (media.name ?? "")
        titleLabel.text = media.original_title ?? "" + (media.original_name ?? "")
        let date = media.release_date ?? "" + (media.first_air_date ?? "")
        releaseDateLabel.text = String(date.dropLast(6))
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (media.poster_path ?? "")) else { return }
        posterView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        posterView.sd_setImage(with: url, completed: nil)
        overviewLabel.text = media.overview
        viewModel.loadTrailers(mediaType: mediaType, movieId: media.id) {
            self.videoCollectionView.reloadData()
        }
    }
    
    private func setupConstraint() {
        view.addSubview(posterView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(genreLabel)
        view.addSubview(overviewLabel)
        view.addSubview(videoCollectionView)
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            posterView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            posterView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.46),
            posterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            posterView.heightAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: 1.5),
            
            titleLabel.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            
            releaseDateLabel.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 16),
            releaseDateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            genreLabel.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 16),
            genreLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            genreLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
            
            overviewLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            overviewLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            overviewLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 10),
            
            videoCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            videoCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            videoCollectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 10),
            videoCollectionView.heightAnchor.constraint(equalTo: videoCollectionView.widthAnchor, multiplier: 0.56),
            
            pageControl.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            pageControl.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            pageControl.topAnchor.constraint(equalTo: videoCollectionView.bottomAnchor, constant: 0),
            
        ])
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = self.viewModel.arrayOfViedos.count
        if count == 1 {
            pageControl.numberOfPages = 0
        } else {
            pageControl.numberOfPages = count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as? VideoCollectionViewCell else { return UICollectionViewCell() }
        cell.playerView.load(withVideoId: self.viewModel.arrayOfViedos[indexPath.row].key)
        return cell
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        pageControl.currentPage = indexPath.row
    }
    
}

