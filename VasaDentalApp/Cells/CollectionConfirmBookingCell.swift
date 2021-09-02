//
//  CollectionConfirmBookingCell.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 11/2/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

protocol CollectionConfirmBookingCellDelegate {
    func buttonTapped(buttonType: ButtonType, booking: BookingModel)
}

class CVConfirmBookingCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    static let reuseID = "reuseID"
    
    private let tableView   = UITableView()
    private let padding     : CGFloat = 20
    private let cellTypes   = CellType.allCases.map { $0 }
    
    private var booking     : BookingModel!
    var delegate            : CollectionConfirmBookingCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        contentView.backgroundColor     = .systemBlue
        contentView.layer.cornerRadius  = 12

        tableView.allowsSelection       = false
        tableView.isScrollEnabled       = false
        tableView.separatorStyle        = .none
        tableView.backgroundColor       = .clear
        tableView.delegate              = self
        tableView.dataSource            = self
        tableView.register(ConfirmBookingCell.self, forCellReuseIdentifier: ConfirmBookingCell.reuseID)
        
        contentView.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            tableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            tableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            tableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    
    func setCell(with booking: BookingModel) {
        self.booking = booking
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTypes.count
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(cellTypes.count)
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConfirmBookingCell.reuseID, for: indexPath) as! ConfirmBookingCell
        cell.setCell(with: cellTypes[indexPath.row], booking: booking)
        cell.delegate = self
        return cell
    }
}

extension CVConfirmBookingCell: ConfirmBookingCellDelegate {
    func buttonTapped(buttonType: ButtonType, booking: BookingModel) {
        delegate?.buttonTapped(buttonType: buttonType, booking: booking)
    }
}
