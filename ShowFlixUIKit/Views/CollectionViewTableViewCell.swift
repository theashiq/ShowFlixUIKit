//
//  CollectionViewTableViewCell.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import UIKit


protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, show: Show)
}

class CollectionViewTableViewCell: UITableViewCell{
    static let identifier = "CollectionViewTableViewCell"
    
    private var shows: [Show] = []
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 140, height: 200)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ShowCollectionViewCell.self, forCellWithReuseIdentifier: ShowCollectionViewCell.identifier)
        
        return collection
    }()
    
    
    private let errorLabel: UILabel = {
        var label = UILabel()
        label.textAlignment = .center
        label.textColor = .label
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemTeal
        contentView.addSubview(collectionView)
        contentView.addSubview(errorLabel)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func layoutSubviews() {
        errorLabel.frame = contentView.bounds
        collectionView.frame = contentView.bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with shows: [Show]) {
        self.shows = shows
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
            self?.errorLabel.text = ""
        }
    }
    public func configure(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.errorLabel.text = error.localizedDescription
            self?.shows = []
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        shows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCollectionViewCell.identifier, for: indexPath) as? ShowCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: .get(from: shows[indexPath.row]))
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.collectionViewTableViewCellDidTapCell(self, show: shows[indexPath.row])
    }
}
