//
//  ShowTableViewCell.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/3/24.
//

import UIKit


protocol ShowTableViewCellDelegate: AnyObject{
    func watchListButtonDidTap(_ show: Show, cell: ShowTableViewCell)
}

class ShowTableViewCell: UITableViewCell{
    
    static let identifier: String = "ShowTableViewCell"
    weak var delegate: ShowTableViewCellDelegate?
    private var viewModel: ShowViewModel!
    
    private let showTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let showDetailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
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
    
    private let watchListButton: UIButton = {
        let button = UIButton()
        var image = UIImage(systemName: "star", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20))
        button.setImage(image, for: .normal)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(showTitleLabel)
        contentView.addSubview(showDetailLabel)
        contentView.addSubview(watchListButton)
        
        watchListButton.addTarget(self, action: #selector(addToWatchListDidPress), for: .touchUpInside)
        
        applyConstraints()
    }
    
    @objc private func addToWatchListDidPress(){
        if let viewModel{
            delegate?.watchListButtonDidTap(viewModel.show, cell: self)
        }
    }
    private func applyConstraints() {
        let posterImageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
        ]
        
        let watchListButtonConstraints = [
            watchListButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            watchListButton.topAnchor.constraint(equalTo: contentView.centerYAnchor),
            watchListButton.heightAnchor.constraint(equalToConstant: 40),
            watchListButton.widthAnchor.constraint(equalToConstant: 40)
        ]
        
        let showTitleLabelConstraints = [
            showTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            showTitleLabel.trailingAnchor.constraint(equalTo: watchListButton.leadingAnchor, constant: -10),
            showTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            showTitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let showDetailLabelConstraints = [
            showDetailLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            showDetailLabel.trailingAnchor.constraint(equalTo: watchListButton.leadingAnchor, constant: -10),
            showDetailLabel.topAnchor.constraint(equalTo: showTitleLabel.bottomAnchor),
            showDetailLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(watchListButtonConstraints)
        NSLayoutConstraint.activate(showTitleLabelConstraints)
        NSLayoutConstraint.activate(showDetailLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: ShowViewModel) {
        self.viewModel = viewModel
        guard let posterUrl = viewModel.posterUrl else{
            self.posterImageView.image = .posterPlaceholder
            self.showDetailLabel.text = ""
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.showTitleLabel.text = viewModel.title
            self?.showDetailLabel.text = viewModel.description
            self?.posterImageView.sd_setImage(with: posterUrl, completed: nil)
            if viewModel.wishListItem{
                self?.watchListButton.setImage(.init(systemName: "star.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20)), for: .normal)
            }
        }
    }
    
    public func configure(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.showTitleLabel.text = "Unknown Show Title"
            self?.showDetailLabel.text = ""
            self?.posterImageView.image = .posterPlaceholder
        }
    }
}
