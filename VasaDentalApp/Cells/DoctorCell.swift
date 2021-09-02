//
//  DoctorCell.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/8/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import Cosmos


class DoctorCell: UICollectionViewCell {
    
    static let reuseID = "reuseID"
    
    private let doctorImage      = UIImageView()
    private let doctorNameLabel  = UILabel()
    private let doctorSpeciality = UILabel()
    private let imageView        = UIImageView()
    private let doctorRating     = CosmosView()
    
    var labelWidthAnchor         : NSLayoutConstraint?
    var doctorName               : String? {
        didSet {
            doctorNameLabel.text = doctorName
            let labelWidth = UIHelper.calculateLabelWidth(text: doctorName!, fontSize: 20, height: 22)
            labelWidthAnchor?.constant = labelWidth
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        setupContentView()
        activateConstraint()
        setupRoundedImageView()
        doctorImage.image = UIImage(systemName: "person.crop.circle")
    }
    
    
    func set(with doctor: DoctorModel) {
        doctorName = doctor.doctorName
        doctorSpeciality.text = doctor.doctorSpeciality
        doctorRating.rating = doctor.doctorRating
    }
    
    
    private func setupContentView() {
        contentView.addSubviews(doctorImage, doctorNameLabel, doctorSpeciality, doctorRating, imageView)
        contentView.layer.borderWidth           = 1
        contentView.layer.cornerRadius          = 12
        contentView.backgroundColor             = .systemBackground
        contentView.layer.borderColor           = UIColor.white.cgColor
        
        contentView.layer.shadowColor           = UIColor.systemGray.cgColor
        contentView.layer.shadowOpacity         = 0.4
        contentView.layer.shadowOffset          = CGSize(width: 0.0, height: 5)
        contentView.layer.shadowRadius          = 7
        
        contentView.layer.shouldRasterize       = true
        contentView.layer.rasterizationScale    = UIScreen.main.scale
        
        doctorRating.settings.updateOnTouch     = false
    }
    
    
    private func setupRoundedImageView() {
        imageView.backgroundColor       = .systemRed
        imageView.layer.cornerRadius    = 12
        imageView.layer.maskedCorners   = [.layerMaxXMaxYCorner, .layerMinXMinYCorner]
        imageView.image                 = UIImage(systemName: "arrow.right")
        imageView.tintColor             = .white
        imageView.contentMode           = .center
    }
    
    
    private func activateConstraint() {
        labelWidthAnchor = doctorNameLabel.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 2)
        
        NSLayoutConstraint.activate([
            doctorImage.heightAnchor.constraint(equalToConstant: 50),
            doctorImage.widthAnchor.constraint(equalToConstant: 50),
            doctorImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            doctorImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            doctorNameLabel.leadingAnchor.constraint(equalTo: doctorImage.trailingAnchor, constant: 10),
            doctorNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            doctorNameLabel.heightAnchor.constraint(equalToConstant: 22),
            
            doctorSpeciality.leadingAnchor.constraint(equalTo: doctorImage.trailingAnchor, constant: 10),
            doctorSpeciality.topAnchor.constraint(equalTo: doctorNameLabel.bottomAnchor, constant: 10),
            doctorSpeciality.widthAnchor.constraint(equalToConstant: contentView.bounds.width / 1.5),
            doctorSpeciality.heightAnchor.constraint(equalToConstant: 18),
            
            doctorRating.leadingAnchor.constraint(equalTo: doctorNameLabel.trailingAnchor, constant: 5),
            doctorRating.centerYAnchor.constraint(equalTo: doctorNameLabel.centerYAnchor),
            doctorRating.heightAnchor.constraint(equalToConstant: 20),
            
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            imageView.widthAnchor.constraint(equalToConstant: 30)
        ])
    }
}
