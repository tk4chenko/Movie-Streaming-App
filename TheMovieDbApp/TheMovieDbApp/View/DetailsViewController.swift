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
    
    let viewModel = ViewModelDetailsVC()
    
    static var identifier = "DetailsViewController"
    private var mediaId = Int()
    
    var arrayOfVideos = [Video]()
    
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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraint()
    }
    
    func createLayout() -> UICollectionViewLayout {
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
        print(mediaId)
    }
    
    public func configure(mediaType: MediaType, media: Media, genres: [Genre]) {
        mediaId = media.id
        title = media.title ?? "" + (media.name ?? "")
        titleLabel.text = media.original_title ?? "" + (media.original_name ?? "")
        let date = media.release_date ?? "" + (media.first_air_date ?? "")
        releaseDateLabel.text = String(date.dropLast(6))
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (media.poster_path ?? "")) else { return }
        posterView.sd_setImage(with: url, completed: nil)
        overviewLabel.text = media.overview
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
        genreLabel.text = g
        viewModel.loadTrailer(mediaType: mediaType, movieId: media.id) { videos in
            DispatchQueue.main.async {
                self.arrayOfVideos = videos
                self.videoCollectionView.reloadData()
            }
        }
    }
    
    private func setupConstraint() {
        view.addSubview(posterView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(genreLabel)
        view.addSubview(overviewLabel)
        view.addSubview(videoCollectionView)
        
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
            videoCollectionView.heightAnchor.constraint(equalTo: videoCollectionView.widthAnchor, multiplier: 0.56)
    
        ])
    }
}

extension DetailsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.arrayOfVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as? VideoCollectionViewCell else { return UICollectionViewCell() }
        cell.playerView.load(withVideoId: arrayOfVideos[indexPath.row].key)
        return cell
        
    }
    
}
