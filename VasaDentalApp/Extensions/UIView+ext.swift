//
//  UIView+ext.swift
//  GitHubFollowers
//
//  Created by Roman Kavinskyi on 29.06.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

extension UIView {
	
	func pinToEdges(of superview: UIView) {
		translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			topAnchor.constraint(equalTo: superview.topAnchor),
			leadingAnchor.constraint(equalTo: superview.leadingAnchor),
			trailingAnchor.constraint(equalTo: superview.trailingAnchor),
			bottomAnchor.constraint(equalTo: superview.bottomAnchor)
		])
	}
	
    
	func addSubviews(_ views: UIView...) {
		for view in views {
            view.translatesAutoresizingMaskIntoConstraints = false
			addSubview(view)
		}
	}
}
