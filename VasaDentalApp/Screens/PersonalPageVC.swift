//
//  PersonalCanetVC.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 11/6/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

class PersonalPageVC: ViewAndConstraintsVC, UICollectionViewDelegate {
    
    typealias DataSource            = UICollectionViewDiffableDataSource<Section, BookingModel>
    typealias Snapshot              = NSDiffableDataSourceSnapshot<Section, BookingModel>
        
    private var dataSource          : DataSource!
    private var snapshot            = Snapshot()
    
    private var collectionView      : UICollectionView!
    private var viewForCollection   : UIView!
    
    private var bookings            : [BookingModel] = []
    private var customer            : [CustomerModel] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        mainLabelText = "Привіт!"
        doctorTextLabel = "Тут буде інформація про тебе та твої візити до доктора!"
        loadCustomer()
        setupViewForCollection()
        setupCollectionView()
        loadBookings()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    private func loadBookings() {
        PersistenceManager.retrieveFavorites { result in
            switch result {
            case .success(let previousBookings):
                guard previousBookings.count > 1  else { return }
                self.bookings.removeAll()
                self.bookings.append(contentsOf: previousBookings)
                self.updateCollectionView()
                
            case .failure(_):
                print("no bookings")
            }
        }
    }
    
    
    private func loadCustomer() {
        PersistenceManager.retrieveCustomers { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let retrievedCustomer):
                self.customer = retrievedCustomer
                guard self.customer.count != 0 else { return }
                self.mainLabelText = "Привіт, \(self.customer[0].name)!"
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    private func cancelBooking(booking: BookingModel) {
        NetworkManager.shared.deleteBooking(bookingID: booking.id.uuidString) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case true:
                DispatchQueue.main.async {
                    PersistenceManager.updateWith(booking: booking, actionType: .remove) { _ in
                        self.bookings.removeAll { $0.id == booking.id }
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
    
    
    func bookingRated(rate: Double, booking: BookingModel) {
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
    
    private func setupViewForCollection() {
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 0
        
        let mainLabelHeight = mainLabelHeightConstraint?.constant ?? padding * 1.5
        let doctorsLabelHeight = doctorsLabelHeightConstraint?.constant ?? padding * 2.5
        let y = mainLabelHeight + doctorsLabelHeight + (padding * 2) + statusBarHeight
        
        
        let height = view.bounds.height - statusBarHeight - tabBarHeight - y - (2 * padding) - 44
        
        viewForCollection = UIView(frame: CGRect(x: padding, y: y, width: view.bounds.width - (padding * 2), height: height))
        
        middleView.addSubview(viewForCollection)
    }
    
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: viewForCollection.frame, collectionViewLayout: UIHelper.createOneColumnFlowLayout(in: viewForCollection, relativePadding: padding))
        collectionView.bounds = viewForCollection.bounds
        viewForCollection.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.register(CVConfirmBookingCell.self, forCellWithReuseIdentifier: CVConfirmBookingCell.reuseID)
        collectionView.delegate = self
        
        setupDataSource()
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
        snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(bookings)
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: false)
        }
    }
    
    
    private func configure() {
        backButton.removeFromSuperview()
        nextButton.removeFromSuperview()
        
        middleView.backgroundColor = .systemBlue
    }
    
    
    func bookingCanceled() {
        let alert = UIAlertController(title: "Бронювання відмінено", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.updateCollectionView()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    func bookingNotCanceled() {
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



extension PersonalPageVC: CollectionConfirmBookingCellDelegate {
    func buttonTapped(buttonType: ButtonType, booking: BookingModel) {
        switch buttonType {
        case .cancel:
            cancelBooking(booking: booking)
        case .rate:
            rateBooking(booking: booking)
        }
    }
    
    
}
