//
//  NextButton.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/14/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class NextButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor     = .systemBlue
        layer.cornerRadius  = 12
        setTitleColor(.systemBackground, for: .normal)
        setTitle("Дальше", for: .normal)
    }
}
