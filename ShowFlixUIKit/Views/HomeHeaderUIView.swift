//
//  HomeHeaderUIView.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import UIKit

protocol HomeHeaderViewDelegate: AnyObject{
    func play(show: Show)
    func download(show: Show)
}

class HomeHeaderUIView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareHeaderView()
    }
    
    weak var delegate: HomeHeaderViewDelegate?
    private var show: Show!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let headerImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(resource: .homeFeedHeader))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.borderColor = UIColor.label.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var gradientLayer: CAGradientLayer = {
       let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        return gradient
    }()
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        playButton.layer.borderColor = UIColor.label.cgColor
        downloadButton.layer.borderColor = UIColor.label.cgColor
    }
    
    private func prepareHeaderView(){
        headerImage.frame = bounds
        gradientLayer.frame = bounds
        addSubview(headerImage)
        layer.addSublayer(gradientLayer)
        
        addSubview(playButton)
        addSubview(downloadButton)
        
        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(downloadPressed), for: .touchUpInside)
        
        applyConstraints()
    }
    
    
    @objc func playPressed() {
        if let show{
            delegate?.play(show: show)
        }
    }
    @objc func downloadPressed() {
        if let show{
            delegate?.download(show: show)
        }
    }
    
    private func applyConstraints(){
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 200),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        NSLayoutConstraint.activate(playButtonConstraints)
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -200),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    func configure(with viewModel: ShowViewModel){
        guard let url = viewModel.posterUrl else {return}
        show = viewModel.show
        
        DispatchQueue.main.async{ [weak self] in
            self?.headerImage.sd_setImage(with: url, completed: nil)
        }
    }
}

