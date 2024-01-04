//
//  WatchListItemTableViewCell.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/4/24.
//

import UIKit

class WatchListItemTableViewCell: UITableViewCell{
    static let identifier = "WatchListItemTableViewCell"
    
    private let showTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(showTitleLabel)
        applyConstraints()
    }
    
    private func applyConstraints() {
        let posterImageViewConstraints = [
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let showTitleLabelConstraints = [
            showTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            showTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            showTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(showTitleLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: ShowViewModel) {
        
        guard let posterUrl = viewModel.posterUrl else{
            self.posterImageView.image = .posterPlaceholder
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.showTitleLabel.text = viewModel.title
            self?.posterImageView.sd_setImage(with: posterUrl, completed: nil)
        }
    }
    
    public func configure(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.showTitleLabel.text = "Unknown Show Title"
            self?.posterImageView.image = .posterPlaceholder
        }
    }
}
