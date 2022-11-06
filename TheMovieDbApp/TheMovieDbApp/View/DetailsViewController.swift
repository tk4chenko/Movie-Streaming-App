//
//  DetailsViewController.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 04.11.2022.
//

import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    let viewModel = ViewModelMoviesVC()
    
    var arrayOfGenres = [Genre]()
    
    static var identifier = "DetailsViewController"
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        //        label.layer.masksToBounds = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
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
    
    private let scoreView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 6
        view.backgroundColor = .systemBlue
        return view
    }()
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        
        viewModel.loadGenresforMovies { genres in
            self.arrayOfGenres = genres
        }
        
        viewModel.loadGenresforTV { genres in
            for genre in genres {
                self.arrayOfGenres.append(genre)
            }
        }
        
    }
    
    public func configure(with media: Media) {
        titleLabel.text = media.title ?? "" + (media.name ?? "")
        let date = media.release_date ?? "" + (media.first_air_date ?? "")
        releaseDateLabel.text = String(date.dropLast(6))
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (media.poster_path ?? "")) else { return }
        posterView.sd_setImage(with: url, completed: nil)
        
        var genres = ""
        
        for id in media.genre_ids {
            for genre in arrayOfGenres {
                if id == genre.id && id == media.genre_ids.last {
                    genres += genre.name
                } else {
                    genres += genre.name + ", "
                }
            }
        }
        
        genreLabel.text = genres
        
    }
    
    private func setupConstraint() {
        view.addSubview(posterView)
        view.addSubview(titleLabel)
        view.addSubview(releaseDateLabel)
        view.addSubview(genreLabel)
        
        NSLayoutConstraint.activate([
            posterView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            posterView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.46),
            posterView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            posterView.heightAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: 1.5),
            
            titleLabel.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            
            releaseDateLabel.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 16),
            releaseDateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            
            genreLabel.leftAnchor.constraint(equalTo: posterView.rightAnchor, constant: 16),
            genreLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            genreLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 8),
        ])
    }
    
    
}
