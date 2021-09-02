//
//  ViewController.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/8/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

enum Section {
    case main
}

class WelcomeVC: UIViewController {
    
    typealias DataSource            = UICollectionViewDiffableDataSource<Section, DoctorModel>
    typealias DataSourceSnapshot    = NSDiffableDataSourceSnapshot<Section, DoctorModel>
    
    private var dataSource          : DataSource!
    private var snapshot            = DataSourceSnapshot()

    private let imageView           = UIImageView()
    private let collectionLabel     = UILabel()
    private var viewForCollection   : UIView!
    
    private var collectionView      : UICollectionView!
    
    private var doctors             : [DoctorModel] = []
    private lazy var padding        : CGFloat = ceil(view.bounds.height * 0.02232143)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMockData()
        configure()
        configureCollectionView()
        configureDataSource()
        updateData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: viewForCollection.bounds, collectionViewLayout: UIHelper.createCellsFlowLayout(in: viewForCollection))
        viewForCollection.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.register(DoctorCell.self, forCellWithReuseIdentifier: DoctorCell.reuseID)
        
    }
    
    private func configureDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, doctor) -> DoctorCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorCell.reuseID, for: indexPath) as! DoctorCell
            cell.set(with: doctor)
            return cell
        })
    }
    
    private func updateData() {
        snapshot = DataSourceSnapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(doctors)
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
    
    private func setupMockData() {
        imageView.image = UIImage(named: "dentistRoom")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let vasa = DoctorModel(doctorName: "Vasa", doctorSpeciality: "SuperDentist", doctorRating: 4.2)
        let petya = DoctorModel(doctorName: "Petro", doctorSpeciality: "SuperDentist", doctorRating: 4.2)
        doctors.append(contentsOf: [vasa, petya])
    }
    
    
    private func configure() {
        view.backgroundColor = .systemBackground

        let x: CGFloat = padding
        let y = (view.bounds.height / 2) + (padding * 5)
        let width = view.bounds.width - (padding * 2)
        let height = view.bounds.height - y
        
        viewForCollection = UIView(frame: CGRect(x: x, y: y, width: width, height: height))
        
        view.addSubviews(imageView, collectionLabel, viewForCollection)
        
        collectionLabel.text = "Доступні доктора"
        collectionLabel.font = .systemFont(ofSize: 24, weight: .semibold)
        
        NSLayoutConstraint.activate([
            collectionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            collectionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            collectionLabel.topAnchor.constraint(equalTo: view.centerYAnchor, constant: padding * 2),
            collectionLabel.heightAnchor.constraint(equalToConstant: padding * 1.5),
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: collectionLabel.topAnchor, constant: -padding),
            
            viewForCollection.topAnchor.constraint(equalTo: collectionLabel.bottomAnchor, constant: 15),
            viewForCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            viewForCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            viewForCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


extension WelcomeVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let appointmentVC = AppointmentVC(doctor: doctors[indexPath.item])
        navigationController?.pushViewController(appointmentVC, animated: true)
    }
}

