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
        // Initialization code
    }
    
    public func configure(with movie: Movie) {
        titleLabel.text = movie.original_title
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500" + (movie.poster_path ?? "")) else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
    }

}
