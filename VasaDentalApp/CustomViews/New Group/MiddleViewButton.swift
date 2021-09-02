//
//  MIddleViewButton.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 11/3/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class MiddleViewButton: UIButton {


    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        setTitle("Відмінити бронювання", for: .normal)
        titleLabel?.numberOfLines = 0
        titleLabel?.textAlignment = .center
        setTitleColor(.systemBackground, for: .normal)
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBackground.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
}
