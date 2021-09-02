//
//  BackButton.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/14/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class BackButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius  = 12
        layer.borderWidth   = 1
        layer.borderColor   = UIColor.systemBlue.cgColor
        setTitleColor(.systemBlue, for: .normal)
        setTitle("Назад", for: .normal)
    }
}
