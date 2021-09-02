//
//  UIHelper.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/8/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

enum UIHelper {
    
    static func createCellsFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width                         = view.bounds.width
        let padding: CGFloat              = 15
        let minimumItemSpacing: CGFloat   = 10
        let availableWidth                = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                     = availableWidth
        
        let flowLayout                    = UICollectionViewFlowLayout()
        flowLayout.sectionInset           = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumLineSpacing     = 20
        flowLayout.itemSize               = CGSize(width: itemWidth, height: 70)
        
        return flowLayout
    }
    
    static func createTwoColumnFlowLayout(in view: UIView, relativePadding: CGFloat) -> UICollectionViewFlowLayout {
        let width                         = view.bounds.width
        let padding: CGFloat              = relativePadding
        let minimumItemSpacing: CGFloat   = 10
        let availableWidth                = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                     = availableWidth / 2
        
        let flowLayout                    = UICollectionViewFlowLayout()
        flowLayout.sectionInset           = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumLineSpacing     = 10
        flowLayout.itemSize               = CGSize(width: itemWidth, height: itemWidth)
        
        return flowLayout
    }
    
    static func createOneColumnFlowLayout(in view: UIView, relativePadding: CGFloat) -> UICollectionViewFlowLayout {
        let width                         = view.bounds.width
        let padding: CGFloat              = relativePadding
        let minimumItemSpacing: CGFloat   = 10
        let availableWidth                = width - (padding * 2) - (minimumItemSpacing * 2)
        let itemWidth                     = availableWidth
        
        let flowLayout                    = UICollectionViewFlowLayout()
        flowLayout.sectionInset           = UIEdgeInsets(top: 0, left: padding, bottom: padding, right: padding)
        flowLayout.minimumLineSpacing     = 10
        flowLayout.itemSize               = CGSize(width: itemWidth, height: view.bounds.height - 60)
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }
    
    
    static func createThreeColumnFlowLayout(in view: UIView) -> UICollectionViewFlowLayout {
        let width                         = view.bounds.width
        let padding: CGFloat              = 10
        let minimumItemSpacing: CGFloat   = 10
        let availableWidth                = width - (padding * 3) - (minimumItemSpacing * 3)
        let itemWidth                     = availableWidth / 3
        
        let flowLayout                    = UICollectionViewFlowLayout()
        flowLayout.sectionInset           = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        flowLayout.minimumLineSpacing     = 15
        flowLayout.itemSize               = CGSize(width: itemWidth, height: 35)
        
        return flowLayout
    }
    
    
    static func calculateLabelWidth(text: String, fontSize: CGFloat, height: CGFloat) -> CGFloat {
        var currentWidth: CGFloat!
        
        let label   = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.text  = text
        label.font  = .systemFont(ofSize: fontSize, weight: .medium)
        label.numberOfLines = 0
        label.sizeToFit()
        currentWidth = label.frame.width
        
        return currentWidth
    }
    
    static func calculateLabelHeight(text: String, fontSize: CGFloat, width: CGFloat) -> CGFloat {
        var currentHeight: CGFloat!
        
        let label   = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.text  = text
        label.font  = .systemFont(ofSize: fontSize, weight: .medium)
        label.numberOfLines = 0
        label.sizeToFit()
        currentHeight = label.frame.height
        
        return currentHeight
    }
}
