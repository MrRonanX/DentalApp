//
//  TableViewConfirmBookingCell.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 11/2/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

protocol ConfirmBookingCellDelegate {
    func buttonTapped(buttonType: ButtonType, booking: BookingModel)
}

enum CellType: CaseIterable {
    case timeToBooking, service, date, time, address, phone, button
}

enum ButtonType {
    case cancel, rate
}

class ConfirmBookingCell: UITableViewCell {
    
    static let reuseID      = "reuseID"
    
    private let cellImage   = UIImageView()
    private let cellLabel   = UILabel()
    private let button      = MiddleViewButton()
    private var buttonType  : ButtonType = .cancel
    private var booking     : BookingModel!
    var delegate            : ConfirmBookingCellDelegate?
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        cellImage.contentMode   = .center
        cellImage.tintColor     = .systemBackground
        
        cellLabel.textColor     = .systemBackground
        cellLabel.font          = .systemFont(ofSize: 16, weight: .regular)
        contentView.addSubviews(cellImage, cellLabel)
        
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cellImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellImage.widthAnchor.constraint(equalToConstant: 30),
            cellImage.heightAnchor.constraint(equalToConstant: 30),
            
            cellLabel.leadingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: 20),
            cellLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            cellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cellLabel.heightAnchor.constraint(equalToConstant: 25)
        ])
    }
    
    func setCell(with cellType: CellType, booking: BookingModel) {
        switch cellType {
        case .timeToBooking:
            setupLabel(with: 16, and: .systemGray4, and: setupLabels(with: booking))
        case .service:
            let bookingText = "\(booking.service) у \(booking.doctor.doctorName)"
            setupLabel(with: 26, and: .systemBackground, and: bookingText)
        case .date:
            configure()
            cellImage.image = UIImage(systemName: "calendar")
            cellLabel.text = booking.date.capitalized
        case .time:
            configure()
            cellImage.image = UIImage(systemName: "clock")
            cellLabel.text = booking.time
        case .address:
            configure()
            cellImage.image = UIImage(systemName: "location")
            cellLabel.text = booking.doctor.address
        case .phone:
            configure()
            cellImage.image = UIImage(systemName: "phone")
            cellLabel.text = booking.doctor.phone
        case .button:
            self.booking = booking
            setupButton(with: booking)
        }
    }
    
    
    @objc private func buttonTapped() {
        switch buttonType {
        case .cancel:
            delegate?.buttonTapped(buttonType: .cancel, booking: booking)
        case .rate:
            delegate?.buttonTapped(buttonType: .rate, booking: booking)
        }
    }
    
    
    private func setupButton(with booking: BookingModel) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        contentView.addSubview(button)
        
        let _ = setupLabels(with: booking)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        switch buttonType {
        case .cancel:
            button.setTitle("Відмінити", for: .normal)
        case .rate:
            button.setTitle("Оцінити", for: .normal)
        }
        
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    
    private func setupLabel(with font: CGFloat, and color: UIColor, and text: String) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        contentView.addSubview(cellLabel)
        cellLabel.translatesAutoresizingMaskIntoConstraints = false
        cellLabel.textColor = color
        cellLabel.font = UIFont.systemFont(ofSize: font, weight: .semibold)
        cellLabel.text = text
        
        NSLayoutConstraint.activate([
            cellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cellLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func setupLabels(with booking: BookingModel) -> String {
        let currentDate = Date().timeIntervalSince1970
        let bookingDate = booking.rawDate.timeIntervalSince1970
        let howManySecondTillBooking = bookingDate - currentDate
        let numberOfDaysTillBooking = Int(ceil(howManySecondTillBooking / 86400))
        print(numberOfDaysTillBooking)
        switch numberOfDaysTillBooking {
        case 1:
            buttonType = .cancel
           return "Завтра"
        case 2...4:
            buttonType = .cancel
            return "Через \(numberOfDaysTillBooking) дня"
        case 5...:
            buttonType = .cancel
            return "Через \(numberOfDaysTillBooking) днів"
        case -1:
            buttonType = .rate
            return "Вчора"
        case -10000 ... -2:
            buttonType = .rate
            return booking.date
        default:
            return "Сьогодні"
        }
    }
}
