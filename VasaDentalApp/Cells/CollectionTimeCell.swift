//
//  CollectionTimeCell.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/15/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class CollectionTimeCell: UICollectionViewCell {
    
    static let reuseID = "reuseID"
    
    private let timeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func updateCGColorsIntoDark() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    
    private func updateCGColorsIntoLight() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemGray4.cgColor
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            updateCGColorsIntoLight()
        case .dark:
            updateCGColorsIntoDark()
        @unknown default:
            updateCGColorsIntoLight()
        }
    }
    
    
    private func configure() {
        backgroundColor     = .systemBackground
        layer.cornerRadius  = 5
        layer.borderWidth   = 1
        layer.borderColor   = UIColor.systemGray4.cgColor
        
        timeLabel.textColor = .label
        timeLabel.font      = .systemFont(ofSize: 13, weight: .medium)
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(timeLabel)
        
        timeLabel.pinToEdges(of: contentView)
    }
    
    
    func setCell(with time: TimeData) {
        timeLabel.text = time.time
        timeLabel.textAlignment = .center
        switch time.isChosen {
        case true:
            backgroundColor = .systemBlue
            timeLabel.textColor = .white
        case false:
            backgroundColor = .systemBackground
            timeLabel.textColor = .label
        }
    }
}

