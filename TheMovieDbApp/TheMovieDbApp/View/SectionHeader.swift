//
//  SectionHeader.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 04.11.2022.
//

import UIKit

class SectionHeader: UICollectionReusableView {
    
    static let identifier = "SectionHeader"
    
    public let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        label.textColor = .black
        return label
    }()
    
    override func layoutSubviews() {
        setupConstraint()
    }
    
    private func setupConstraint() {
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
}
