//
//  GenreCell.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 14.11.2022.
//

import UIKit

class GenreCell: UICollectionViewCell {
    
    static var identifier = "GenreCell"
    
    private let container: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(container)
        container.addSubview(titleLabel)
        container.frame = contentView.bounds
        titleLabel.frame = container.bounds
    }
    
    public func configure(with genre: Genre) {
        
        titleLabel.text = genre.name
    }
}
