//
//  MovieCollectionViewCell.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 02.11.2022.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureShadow()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureShadow()
    }
    
    private func configureShadow() {
 
//        posterImageView.layer.shadowRadius = 8
//        posterImageView.layer.shadowOffset = CGSize(width: -2, height: 2)
//        posterImageView.layer.shadowOpacity = 0.5
//        posterImageView.layer.shadowColor = UIColor.black.cgColor
//
//        posterImageView.layer.cornerRadius = 8
//        posterImageView.layer.masksToBounds = false

        posterImageView.layer.shadowColor = UIColor.black.cgColor
        posterImageView.layer.shadowOpacity = 0.3
        posterImageView.layer.shadowOffset = CGSize.zero
        posterImageView.layer.shadowRadius = 6
        posterImageView.layer.masksToBounds = true
        posterImageView.layer.borderWidth = 1.5
        posterImageView.layer.borderColor = UIColor.white.cgColor
        posterImageView.layer.cornerRadius = 8
    }
    
    public func configure(with title: Title) {
        titleLabel.text = String(title.title ?? "" + (title.name ?? ""))
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (title.poster_path ?? "")) else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }

}
