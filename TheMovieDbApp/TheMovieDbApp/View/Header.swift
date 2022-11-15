//
//  Header.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 14.11.2022.
//

import UIKit

class Header: UICollectionReusableView {
    
    static let headerID = "headerID"
    
    var label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.text = "Header"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        //        label.frame = bounds
        
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8),
            label.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8),
            label.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 0),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
