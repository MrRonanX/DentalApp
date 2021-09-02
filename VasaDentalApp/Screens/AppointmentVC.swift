//
//  AppointmentVC.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/10/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

struct DentalService: Hashable {
    
    var serviceName : String
    var picture     : UIImage
    var selected    : Bool
}

class AppointmentVC: ViewAndConstraintsVC {
    
    typealias DataSource    = UICollectionViewDiffableDataSource<Section, DentalService>
    typealias Snapshot      = NSDiffableDataSourceSnapshot<Section, DentalService>
    
    var dataSource          : DataSource!
    var snapshot            = Snapshot()
    
    var services            : [DentalService] = []
    
    let collectionViewLabel = UILabel()
    var viewForCollection   : UIView!
    var collectionView      : UICollectionView!
    
    var pressedItem         = IndexPath()
    var selectedDoctor      : DoctorModel!
    var selectedService     = ""
    
    
    init(doctor: DoctorModel) {
        super.init(nibName: nil, bundle: nil)
        selectedDoctor  = doctor
        doctorTextLabel = doctor.doctorName
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        createServices()
        configureCollectionView()
        configureDataSource()
        setupSnapshot()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    private func createServices() {
        let serviceOne      = DentalService(serviceName: "Консультація", picture: UIImage(systemName: "person.2")!, selected: false)
        let serviceTwo      = DentalService(serviceName: "Біль в зубі", picture: UIImage(systemName: "ear")!, selected: false)
        let serviceThree    = DentalService(serviceName: "Чистка зубів", picture: UIImage(systemName: "hand.thumbsup")!, selected: false)
        let serviceFour     = DentalService(serviceName: "Брекети", picture: UIImage(systemName: "hand.draw")!, selected: false)
        let serviceFive     = DentalService(serviceName: "Імпланти", picture: UIImage(systemName: "hand.point.right")!, selected: false)
        
        services.append(contentsOf: [serviceOne, serviceTwo, serviceThree, serviceFour, serviceFive])
    }
    
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc private func nextButtonTapped() {
        let timeBookingVC = TimeBookingVC(doctor: selectedDoctor, service: selectedService)
        navigationController?.pushViewController(timeBookingVC, animated: true)
    }
    
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: viewForCollection.bounds, collectionViewLayout: UIHelper.createTwoColumnFlowLayout(in: viewForCollection, relativePadding: padding))
        viewForCollection.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.register(DentalServiceCell.self, forCellWithReuseIdentifier: DentalServiceCell.reuseID)
    }
    
    
    private func setupSnapshot() {
        snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(services)
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, service) -> DentalServiceCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DentalServiceCell.reuseID, for: indexPath) as! DentalServiceCell
            cell.set(service: service)
            return cell
        })
    }
    
    
    private func configure() {
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0 // bottom safe area for devices without home button

        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let navBarHeight = navigationController?.navigationBar.frame.height ?? 44
        let tabBarHeight = tabBarController?.tabBar.frame.height ?? 49
        
        let mainLabelHeight = mainLabelHeightConstraint?.constant ?? padding * 1.5
        let doctorsLabelHeight = doctorsLabelHeightConstraint?.constant ?? padding * 2.5

        let x: CGFloat = padding * 1.5
        let y: CGFloat = statusBarHeight + navBarHeight + (padding * 4) - mainLabelHeight - doctorsLabelHeight
        let width = view.bounds.width - (padding * 3)
        let height = view.bounds.height - statusBarHeight - navBarHeight - tabBarHeight - bottomPadding - (padding * 7) - 44 - mainLabelHeight - doctorsLabelHeight
        
        viewForCollection = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        middleView.addSubviews(collectionViewLabel, viewForCollection)
        
        collectionViewLabel.text = "ЯК МИ МОЖЕМО ВАМ ДОПОМОГТИ?"
        collectionViewLabel.font = .systemFont(ofSize: 15, weight: .medium)
        collectionViewLabel.textColor = .secondaryLabel
        
        viewForCollection.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            collectionViewLabel.topAnchor.constraint(equalTo: middleView.topAnchor, constant: padding / 2),
            collectionViewLabel.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: padding),
            collectionViewLabel.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: -padding),
            collectionViewLabel.heightAnchor.constraint(equalToConstant: padding),
            
            viewForCollection.topAnchor.constraint(equalTo: collectionViewLabel.bottomAnchor, constant: padding / 2),
            viewForCollection.leadingAnchor.constraint(equalTo: middleView.leadingAnchor, constant: 0),
            viewForCollection.trailingAnchor.constraint(equalTo: middleView.trailingAnchor, constant: 0),
            viewForCollection.bottomAnchor.constraint(equalTo: middleView.bottomAnchor, constant: -padding / 2)
        ])
    }
}

extension AppointmentVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if pressedItem != indexPath { for (i, _) in services.enumerated() { services[i].selected = false } }
        services[indexPath.item].selected.toggle()
        selectedService = services[indexPath.item].serviceName
        pressedItem = indexPath
        setupSnapshot()
    }
}
