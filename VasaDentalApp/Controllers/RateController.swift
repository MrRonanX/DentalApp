//
//  RateController.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 11/4/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import Cosmos

protocol RateDelegate {
    func bookingRated(rate: Double)
}

class RateController: UIViewController {
    
    let contentView = UIView()
    let rate = CosmosView()
    let button = UIButton()
    
    var delegate: RateDelegate?
    
    init(delegate: RateDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.75)
        configureRate()
    }
    
    
    private func configureRate() {
        rate.layer.cornerRadius = 12
        rate.layer.borderWidth = 1
        rate.layer.borderColor = UIColor.white.cgColor
        
        rate.backgroundColor = .systemBackground
        rate.translatesAutoresizingMaskIntoConstraints = false
        
        rate.rating = 0.0
        rate.settings.starSize = 45
        view.addSubview(rate)
        
        rate.didFinishTouchingCosmos = { [weak self] rate in
            guard let self = self else { return }
            self.delegate?.bookingRated(rate: rate)
            self.dismiss(animated: true, completion: nil)
        }
        
        NSLayoutConstraint.activate([
            rate.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rate.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rate.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.6),
            rate.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07)
        ])
    }
}

