//
//  ViedoCollectionViewCell.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 06.11.2022.
//

import UIKit
import youtube_ios_player_helper

class VideoCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "VideoCollectionViewCell"
    
    private let playerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleToFill
        view.backgroundColor = .systemRed
        return view
    }()
    
    override func layoutSubviews() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        contentView.addSubview(playerView)
        NSLayoutConstraint.activate([
            playerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0),
            playerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0),
            playerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            playerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
        ])
    }
    
    
}
