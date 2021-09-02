//
//  ViewAndConstraintsVC.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/14/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class ViewAndConstraintsVC: UIViewController {
    
    let mainLabel       = UILabel()
    let doctorsLabel    = UILabel()
    
    var mainLabelHeightConstraint: NSLayoutConstraint?
    var mainLabelText: String? {
        didSet {
            mainLabel.text = mainLabelText
            let height = UIHelper.calculateLabelHeight(text: mainLabel.text!, fontSize: 26, width: view.bounds.width - (2 * padding))
            mainLabelHeightConstraint?.constant = height
        }
    }
    
    var doctorsLabelHeightConstraint: NSLayoutConstraint?
    var doctorTextLabel: String? {
        didSet {
            doctorsLabel.text = doctorTextLabel
            let height = UIHelper.calculateLabelHeight(text: doctorsLabel.text!, fontSize: 18, width: view.bounds.width - (2 * padding))
            doctorsLabelHeightConstraint?.constant = height
        }
    }
    
    let nextButton = NextButton()
    let backButton = BackButton()
    
    let middleView = MiddleView()
    
    lazy var padding: CGFloat = ceil(view.bounds.height * 0.02232143)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        mainLabelText = "Забронювати зустріч"
        
    }
    
    //
    //    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    //        super.traitCollectionDidChange(previousTraitCollection)
    //        switch traitCollection.userInterfaceStyle {
    //        case .light, .unspecified:
    //            view.backgroundColor = .secondarySystemBackground
    //            middleView.backgroundColor = .systemBackground
    //        case .dark:
    //            view.backgroundColor = .systemBackground
    //            middleView.backgroundColor = .secondarySystemBackground
    //        @unknown default:
    //            view.backgroundColor = .secondarySystemBackground
    //            middleView.backgroundColor = .systemBackground
    //        }
    //    }
    
    private func configure() {
        view.backgroundColor = .secondarySystemBackground
        
        doctorsLabel.textColor = .secondaryLabel
        doctorsLabel.numberOfLines = 0
        doctorsLabel.font = .systemFont(ofSize: 18, weight: .medium)
        
        mainLabel.textColor = .label
        mainLabel.font = .systemFont(ofSize: 26, weight: .semibold)
        
        view.addSubviews(mainLabel, doctorsLabel, nextButton, backButton, middleView)
        
        doctorsLabelHeightConstraint = doctorsLabel.heightAnchor.constraint(equalToConstant: padding)
        doctorsLabelHeightConstraint?.isActive = true
        
        mainLabelHeightConstraint = mainLabel.heightAnchor.constraint(equalToConstant: padding * 1.5)
        mainLabelHeightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: padding / 2),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            mainLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            doctorsLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: padding / 2),
            doctorsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            doctorsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            nextButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: padding),
            nextButton.heightAnchor.constraint(equalToConstant: 44),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -padding),
            backButton.heightAnchor.constraint(equalToConstant: 44),
            backButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -padding / 2),
            
            middleView.topAnchor.constraint(equalTo: doctorsLabel.bottomAnchor, constant: padding),
            middleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 1.5),
            middleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 1.5),
            middleView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -padding)
        ])
    }
    
    
    func getEndpointOfNavBar() -> CGFloat{
        var statusBarHeight: CGFloat {
            var heightToReturn: CGFloat = 0.0
            for window in UIApplication.shared.windows {
                if let height = window.windowScene?.statusBarManager?.statusBarFrame.height, height > heightToReturn {
                    heightToReturn = height
                }
            }
            return heightToReturn
        }
        
        let height = (navigationController?.navigationBar.frame.size.height)! + statusBarHeight
        return height
    }
    
    
}
