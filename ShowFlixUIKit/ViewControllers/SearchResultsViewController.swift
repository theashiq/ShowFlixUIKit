//
//  SearchResultsViewController.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/3/24.
//

import UIKit
protocol SearchResultsCellDelegate: AnyObject{
    func searchResultsCellDidTapCell(show: Show)
}

class SearchResultsViewController: UIViewController {
    
    private var shows: [Show] = []
    weak var delegate: SearchResultsCellDelegate?
    
    private let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = .init()
        layout.itemSize = .init(width: 140, height: 200)
        layout.minimumLineSpacing = 0
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        view.addSubview(errorLabel)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        errorLabel.frame = view.bounds
        collectionView.frame = view.bounds
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

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
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
        delegate?.searchResultsCellDidTapCell(show: shows[indexPath.row])
    }
}
