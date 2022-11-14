//
//  TrendingCell.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 14.11.2022.
//

import UIKit

class TrendingCell: UICollectionViewCell {
    static var identifier = "TrendingCell"
    
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
        contentView.addSubview(posterView)
        posterView.frame = contentView.bounds
    }
    
    public func configure(with title: Media) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (title.backdrop_path ?? "")) else { return }
        posterView.sd_setImage(with: url, completed: nil)
    }
    
}
