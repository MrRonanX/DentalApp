//
//  TimeCell.swift
//  VasaDentalApp
//
//  Created by Roman Kavinskyi on 9/15/20.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit

protocol TimeCellDelegate {
    func timeTapped(item: Int, section: Int, chosenTime: String)
}

class TimeCell: UITableViewCell {
    
    static let reuseID = "reuseID"
    var delegate: TimeCellDelegate?
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, TimeData>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, TimeData>
    
    private var dataSource      : DataSource!
    private var snapshot        = Snapshot()
     
    private var collectionView  : UICollectionView!
    
    private var section         = 0
    var doctorsTime             : [TimeData] = []
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(frame: CGRect, layout: UICollectionViewFlowLayout) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        backgroundColor = .systemBackground
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        contentView.addSubview(collectionView)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        collectionView.register(CollectionTimeCell.self, forCellWithReuseIdentifier: CollectionTimeCell.reuseID)
        setupDataSource()
    }
    
    private func setupDataSource() {
        dataSource = DataSource(collectionView: collectionView, cellProvider: { (collectionView, indexPath, doctorsTime) -> CollectionTimeCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionTimeCell.reuseID, for: indexPath) as! CollectionTimeCell
            
            cell.setCell(with: doctorsTime)
            return cell
        })
    }
    
    func applySnapshot() {
        snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(doctorsTime)
        DispatchQueue.main.async {
            self.dataSource.apply(self.snapshot, animatingDifferences: true, completion: nil)
        }
    }
    
    
    func setCell(with time: [TimeData], section: Int) {
        doctorsTime = time
        self.section = section
        applySnapshot()
    }
}

extension TimeCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.timeTapped(item: indexPath.item, section: section, chosenTime: doctorsTime[indexPath.item].time)
        doctorsTime[indexPath.item].isChosen = true
        applySnapshot()
    }
}
