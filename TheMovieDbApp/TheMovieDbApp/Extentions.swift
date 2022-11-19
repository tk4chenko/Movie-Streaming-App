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
    
    func genres(headerID: String)  -> NSCollectionLayoutSection? {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(40)))
        //        item.contentInsets.trailing = 8
        item.contentInsets.leading = 8
        //        item.contentInsets.bottom = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(40)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        //        section.contentInsets.leading = 16
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(40)), elementKind: headerID, alignment: .topLeading)]
        
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

extension UISegmentedControl {
  
  func removeBorder(){
    var bgcolor: CGColor
    var textColorNormal: UIColor
    var textColorSelected: UIColor
    
    if self.traitCollection.userInterfaceStyle == .dark {
      bgcolor = UIColor.black.cgColor
      textColorNormal = UIColor.gray
      textColorSelected = UIColor.white
    } else {
      bgcolor = UIColor.white.cgColor
      textColorNormal = UIColor.gray
      textColorSelected = UIColor.red
    }
    
    let backgroundImage = UIImage.getColoredRectImageWith(color: bgcolor, andSize: self.bounds.size)
    self.setBackgroundImage(backgroundImage, for: .normal, barMetrics: .default)
    self.setBackgroundImage(backgroundImage, for: .selected, barMetrics: .default)
    self.setBackgroundImage(backgroundImage, for: .highlighted, barMetrics: .default)

    let deviderImage = UIImage.getColoredRectImageWith(color: bgcolor, andSize: CGSize(width: 1.0, height: self.bounds.size.height))
    self.setDividerImage(deviderImage, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
    self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColorNormal], for: .normal)
    self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: textColorSelected], for: .selected)
    
  }
  
  func setupSegment() {
      DispatchQueue.main.async() {
    self.removeBorder()
    self.addUnderlineForSelectedSegment()
    }
  }
  
  func addUnderlineForSelectedSegment(){
    DispatchQueue.main.async() {
      self.removeUnderline()
      let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments) - 5
      let underlineHeight: CGFloat = 2.0
      let underlineXPosition = CGFloat(self.selectedSegmentIndex * Int(underlineWidth) + 5)
      let underLineYPosition = self.bounds.size.height - 4
      let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
      let underline = UIView(frame: underlineFrame)
      underline.backgroundColor = UIColor.red
      underline.tag = 1
      self.addSubview(underline)
      
    }
  }
  
    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition
    }
  
  func removeUnderline(){
    guard let underline = self.viewWithTag(1) else {return}
    underline.removeFromSuperview()
  }
}


extension UIImage{

  class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage{
    UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
    let graphicsContext = UIGraphicsGetCurrentContext()
    graphicsContext?.setFillColor(color)
    let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
    graphicsContext?.fill(rectangle)
    let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return rectangleImage!
  }
}
