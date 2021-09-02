//
//  DateSectionCell.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/15/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class DateSectionCell: UITableViewHeaderFooterView {
    
    let dateLabel = UILabel()

    static let reuseID = "reuseID"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.backgroundColor = .systemBackground
        
        dateLabel.textColor = .label
        dateLabel.font = .systemFont(ofSize: 15, weight: .medium)
        contentView.addSubview(dateLabel)

        dateLabel.pinToEdges(of: contentView)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setCell(with month: String, and date: String) {
        dateLabel.text = "\(date) \(month.uppercased())"
    }
    
    
    func showCalendar() {
        dateLabel.text = "ПОКАЗАТИ КАЛЕНДАР"
        dateLabel.textColor = .systemBlue
        dateLabel.font = .systemFont(ofSize: 15, weight: .medium)
    }
}
