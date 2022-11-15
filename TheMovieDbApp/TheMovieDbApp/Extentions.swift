//
//  Extentions.swift
//  TheMovieDbApp
//
//  Created by Artem Tkachenko on 14.11.2022.
//

import Foundation
import UIKit

extension UICollectionView {
 
    func trendingMovies(headerID: String) -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets.leading = 8
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.95), heightDimension: .fractionalWidth(0.95 * 0.62)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: headerID, alignment: .topLeading)]
        return section
        
    }
    
    func genres()  -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(40)))
//        item.contentInsets.trailing = 8
        item.contentInsets.leading = 8
//        item.contentInsets.bottom = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(40)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
//        section.contentInsets.leading = 16
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
//        section.boundarySupplementaryItems = [
//            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: headerID, alignment: .topLeading)]
        
        return section
    }
    
    func upcoming(headerID: String) -> NSCollectionLayoutSection? {
        
        let spacing: CGFloat = 8
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 0, leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(185), heightDimension: .absolute(280))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
//                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                                        heightDimension: .estimated(50.0))
//                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
//                                                                         elementKind: UICollectionView.elementKindSectionHeader,
//                                                                         alignment: .top)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
//                section.boundarySupplementaryItems = [header]
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: headerID, alignment: .topLeading)]
        
        return section
    }
    
}

extension UIColor {
    static var random: UIColor {
        return UIColor(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            alpha: 1.0
        )
    }
}
