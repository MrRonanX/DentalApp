//
//  DentalServiceCell.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/14/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class DentalServiceCell: UICollectionViewCell {
    
    static let reuseID = "reuseID"
    
    private let servicePic      = UIImageView()
    private let serviceLabel    = UILabel()

    
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
        contentView.addSubviews(servicePic, serviceLabel)
        layer.cornerRadius      = 12
        layer.borderWidth       = 1
        layer.borderColor       = UIColor.systemGray4.cgColor
        
        servicePic.tintColor    = .systemBlue
        servicePic.contentMode  = .center
        
        serviceLabel.textColor  = .label
        serviceLabel.font       = .systemFont(ofSize: 14, weight: .regular)
        serviceLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            servicePic.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -15),
            servicePic.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            servicePic.widthAnchor.constraint(equalToConstant: 40),
            servicePic.heightAnchor.constraint(equalToConstant: 40),
            
            serviceLabel.topAnchor.constraint(equalTo: servicePic.bottomAnchor, constant: 5),
            serviceLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            serviceLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            serviceLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    
    func set(service: DentalService) {
        serviceLabel.text = service.serviceName
        servicePic.image = service.picture
        switch service.selected {
        case true:
            backgroundColor = .systemBlue
            servicePic.tintColor = .systemBackground
        case false:
            backgroundColor = .systemBackground
            servicePic.tintColor = .systemBlue
        }
    }
    
    
    func cellSelected() {
        backgroundColor = .systemBlue
        servicePic.tintColor = .systemBackground
    }
    
    
    func cellDeselected() {
        backgroundColor = .systemBackground
        servicePic.tintColor = .systemBlue
    }
}
