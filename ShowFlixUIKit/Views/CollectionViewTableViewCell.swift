//
//  CollectionViewTableViewCell.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import UIKit

class CollectionViewTableViewCell: UITableViewCell{
    static let identifier = "CollectionViewTableViewCell"
    
    
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 140, height: 200)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemTeal
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}

