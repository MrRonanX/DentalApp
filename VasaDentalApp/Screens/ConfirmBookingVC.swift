//
//  ConfirmBookingVC.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/19/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import SDCAlertView
import Cosmos



class ConfirmBookingVC: ViewAndConstraintsVC, UICollectionViewDelegate {
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, BookingModel>
    typealias DataSourceSnapshot = NSDiffableDataSourceSnapshot<Section, BookingModel>
    
    private var dataSource          : DataSource!
    private var snapshot            = DataSourceSnapshot()
    
    private var collectionView      : UICollectionView!
    private var viewForCollection   : UIView!
    
    private let upcomingButton      = UIButton()
    private let pastButton          = UIButton()
    
    private var pastBookings        : [BookingModel] = []
    
    private var booking             : BookingModel!
    private var vaporBooking        : VaporBooking!
    
    
    init(booking: BookingModel, vaporBooking: VaporBooking) {
        super.init(nibName: nil, bundle: nil)
        self.booking = booking
        self.vaporBooking = vaporBooking
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setupMiddleView()
        setupCollectionView()
        saveBooking()
        updateCollectionView()
        
    }
    
    
    private func saveBooking() {
        NetworkManager.shared.saveBooking(booking: vaporBooking) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case true:
                DispatchQueue.main.async {
                    PersistenceManager.updateWith(booking: self.booking, actionType: .add) { [weak self] _ in
                        guard let self = self else { return }
                        self.successfulBooking()
                    }
                }
                
            case false:
                DispatchQueue.main.async {
                    self.unSuccessfulBooking()
                }
            }
        }
    }
    
    
    private func cancelBooking() {
        NetworkManager.shared.deleteBooking(bookingID: vaporBooking.id.uuidString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case true:
                DispatchQueue.main.async {
                    PersistenceManager.updateWith(booking: self.booking, actionType: .remove) { _ in
                        print("deleted")
                    }
                    self.bookingCanceled()
                }
                
            case false:
                DispatchQueue.main.async {
                    self.bookingNotCanceled()
                }
            }
        }
    }
    
    
    private func bookingRated(rate: Double, booking: BookingModel) {
        let ratedBooking = VaporBooking(id: booking.id, service: "", doctorName: "", date: Date(), time: "", address: "", phoneNumber: "", email: "", rating: rate)
        
        NetworkManager.shared.addRating(booking: ratedBooking) { result in
            switch result {
            case true:
                print(result)
            case false:
                print(result)
            }
        }
    }
    
    
    @objc private func upcomingButtonTapped() {
        mainLabelText = "Ваше бронювання"
        upcomingButton.setTitleColor(.systemTeal, for: .normal)
        upcomingButton.backgroundColor = .systemBackground
        
        pastButton.setTitleColor(.systemGray, for: .normal)
        pastButton.backgroundColor = .systemGray4
        
        pastBookings = []
        pastBookings.append(booking)
        
        updateCollectionView()
    }
    
    
    @objc private func pastButtonTapped() {
        mainLabelText = "Ваші минулі бронювання"
        
        upcomingButton.setTitleColor(.systemGray, for: .normal)
        upcomingButton.backgroundColor = .systemGray4
        
        pastButton.setTitleColor(.systemTeal, for: .normal)
        pastButton.backgroundColor = .systemBackground
        
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let previousBookings):
                guard previousBookings.count > 1  else { return }
                self.pastBookings = []
                self.pastBookings.append(contentsOf: previousBookings)
                self.updateCollectionView()
                
            case .failure(_):
                print("no bookings")
            }
        }
    }
    
    
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, booking) -> CVConfirmBookingCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CVConfirmBookingCell.reuseID, for: indexPath) as! CVConfirmBookingCell
            cell.setCell(with: booking)
            cell.delegate = self
            return cell
        })
    }
    
    
    private func updateCollectionView() {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(pastBookings)
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    
    private func configure() {
        mainLabelText = "Ваше бронювання"
        
        doctorsLabel.removeFromSuperview()
        nextButton.removeFromSuperview()
        backButton.removeFromSuperview()
        view.addSubviews(upcomingButton, pastButton)
        
        upcomingButton.setTitle("Майбутнє", for: .normal)
        upcomingButton.setTitleColor(.systemTeal, for: .normal)
        upcomingButton.backgroundColor = .systemBackground
        upcomingButton.layer.cornerRadius = 5
        upcomingButton.addTarget(self, action: #selector(upcomingButtonTapped), for: .touchUpInside)
        
        pastButton.setTitle("Минулі", for: .normal)
        pastButton.setTitleColor(.systemGray, for: .normal)
        pastButton.backgroundColor = .systemGray4
        pastButton.layer.cornerRadius = 5
        pastButton.addTarget(self, action: #selector(pastButtonTapped), for: .touchUpInside)
        
        middleView.backgroundColor = .systemBlue
        middleView.layer.borderColor = UIColor.systemBlue.cgColor
        middleView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            upcomingButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: padding),
            upcomingButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            upcomingButton.heightAnchor.constraint(equalToConstant: 44),
            upcomingButton.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            
            pastButton.topAnchor.constraint(equalTo: mainLabel.bottomAnchor,constant: padding),
            pastButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            pastButton.heightAnchor.constraint(equalToConstant: 44),
            pastButton.leadingAnchor.constraint(equalTo: view.centerXAnchor),
            
            middleView.topAnchor.constraint(equalTo: upcomingButton.bottomAnchor, constant: 2 * padding),
            middleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding * 1.5),
            middleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding * 1.5),
            middleView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -padding * 4)
        ])
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: viewForCollection.bounds, collectionViewLayout: UIHelper.createOneColumnFlowLayout(in: viewForCollection, relativePadding: padding))
        collectionView.bounds = viewForCollection.bounds
        viewForCollection.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.register(CVConfirmBookingCell.self, forCellWithReuseIdentifier: CVConfirmBookingCell.reuseID)
        collectionView.delegate = self
        setupDataSource()
    }
    
    private func setupMiddleView() {
        pastBookings = []
        pastBookings.append(booking)
        
        let x = padding
        let y = 4.5 * padding + 54
        let width = view.bounds.width - padding
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let status = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let height = view.bounds.height - y - (navigationController?.navigationBar.frame.height)! - status - (4 * padding)
        viewForCollection = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        viewForCollection.translatesAutoresizingMaskIntoConstraints = false
        viewForCollection.backgroundColor = .clear
    
        middleView.addSubviews(viewForCollection)
        
        NSLayoutConstraint.activate([
            viewForCollection.topAnchor.constraint(equalTo: middleView.topAnchor),
            viewForCollection.leadingAnchor.constraint(equalTo: middleView.leadingAnchor),
            viewForCollection.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: padding),
            viewForCollection.bottomAnchor.constraint(equalTo: middleView.bottomAnchor)
        ])
    }
    
    
    private func unSuccessfulBooking() {
        let alert = UIAlertController(title: "Невдалось забронювати", message: "Перевірте статус вашого інтернет підлючення або зателефонуйте нам 0123321123", preferredStyle: .alert)
        let action = UIAlertAction(title: "Гаразд", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func successfulBooking() {
        let alert = UIAlertController(title: "Успішне бронювання", message: "Незабаром ми Вам заталефонуємо щоб підтвердити бронювання", preferredStyle: .alert)
        let action = UIAlertAction(title: "Гаразд", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func bookingCanceled() {
        let alert = UIAlertController(title: "Бронювання відмінено", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func bookingNotCanceled() {
        let alert = UIAlertController(title: "Помилка!", message: "Бронювання не було відмено через проблему з інтернет підключенням. Зателефонуйте нам на номер 123321123", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            guard let number = URL(string: "tel://123321123") else { return }
            UIApplication.shared.open(number, options: [:]) { [weak self] _ in
                guard let self = self else { return }
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func rateBooking(booking: BookingModel) {
        let alert = UIAlertController(title: "Оціни сервіс", message: nil, preferredStyle: .actionSheet)
        let oneStar = UIAlertAction(title: "⭐️", style: .default) { [weak self]  _ in
            guard let self = self else { return }
            self.bookingRated(rate: 1.0, booking: booking)
        }
        let twoStars = UIAlertAction(title: "⭐️⭐️", style: .default) { [weak self]  _ in
            guard let self = self else { return }
            self.bookingRated(rate: 2.0, booking: booking)
        }
        let threeStars = UIAlertAction(title: "⭐️⭐️⭐️", style: .default) { [weak self]  _ in
            guard let self = self else { return }
            self.bookingRated(rate: 3.0, booking: booking)
        }
        let fourStars = UIAlertAction(title: "⭐️⭐️⭐️⭐️", style: .default) { [weak self]  _ in
            guard let self = self else { return }
            self.bookingRated(rate: 4.0, booking: booking)
        }
        let fiveStars = UIAlertAction(title: "⭐️⭐️⭐️⭐️⭐️", style: .default) { [weak self]  _ in
            guard let self = self else { return }
            self.bookingRated(rate: 5.0, booking: booking)
        }
        let cancel = UIAlertAction(title: "Відмінити", style: .cancel, handler: nil)
        
        alert.addAction(oneStar)
        alert.addAction(twoStars)
        alert.addAction(threeStars)
        alert.addAction(fourStars)
        alert.addAction(fiveStars)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
}


extension ConfirmBookingVC: CollectionConfirmBookingCellDelegate {
    func buttonTapped(buttonType: ButtonType, booking: BookingModel) {
        switch buttonType {
        case .cancel:
            cancelBooking()
        case .rate:
            rateBooking(booking: booking)
        }
    }
}
