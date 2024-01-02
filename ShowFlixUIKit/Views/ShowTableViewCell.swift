//
//  ShowTableViewCell.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/3/24.
//

import UIKit

class ShowTableViewCell: UITableViewCell{
    
    static let identifier: String = "ShowTableViewCell"
    
    private let showTitleLabel: UILabel = {
        let label = UILabel()
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
    
    private let playButton: UIButton = {
        let button = UIButton()
        var image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 35))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(posterImageView)
        contentView.addSubview(showTitleLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        let posterImageViewConstraints = [
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
        ]
        
        let playButtonLabelConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 50),
        ]
        
        let showTitleLabelConstraints = [
            showTitleLabel.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            showTitleLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor, constant: 10),
            showTitleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraints)
        NSLayoutConstraint.activate(playButtonLabelConstraints)
        NSLayoutConstraint.activate(showTitleLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with show: ShowViewModel) {
        guard let posterUrl = show.posterUrl else{
            self.posterImageView.image = .posterPlaceholder
            return
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.showTitleLabel.text = show.title
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
