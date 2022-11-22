//
//  TrendingCell.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 14.11.2022.
//

import UIKit
import SDWebImage

class TrendingCell: UICollectionViewCell {
    
    static var identifier = "TrendingCell"
    
    private let titleLabel: UILabel = {
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
        view.backgroundColor = .systemPink
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
    
    private let posterView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 6
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
//        contentView.addSubview(posterView)
//        posterView.frame = contentView.bounds
        setupConstraint()
    }
    
    public func configure(with title: Media) {
        scoreView.backgroundColor = .systemPink
        scoreLabel.text = String(Int(title.vote_average * 10)) + "%"
        titleLabel.text = String(title.title ?? "" + (title.name ?? ""))
        guard let url = URL(string: "https://image.tmdb.org/t/p/original" + (title.backdrop_path ?? "")) else { return }
        posterView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        posterView.sd_setImage(with: url, completed: nil)
    }
    
    private func setupConstraint() {
        contentView.addSubview(posterView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(scoreView)
        scoreView.addSubview(scoreLabel)
        
        NSLayoutConstraint.activate([

            posterView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            posterView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            posterView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            posterView.heightAnchor.constraint(equalTo: posterView.widthAnchor, multiplier: 0.56),

            titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            titleLabel.topAnchor.constraint(equalTo: posterView.bottomAnchor, constant: 6),
  
            scoreView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8),
            scoreView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            scoreView.heightAnchor.constraint(equalToConstant: 20),
            scoreView.widthAnchor.constraint(equalToConstant: 35),

            scoreLabel.leftAnchor.constraint(equalTo: scoreView.leftAnchor, constant: 4),
            scoreLabel.rightAnchor.constraint(equalTo: scoreView.rightAnchor, constant: -4),
            scoreLabel.topAnchor.constraint(equalTo: scoreView.topAnchor, constant: 2),
            scoreLabel.bottomAnchor.constraint(equalTo: scoreView.bottomAnchor, constant: -2)
        ])
    }
    
}
