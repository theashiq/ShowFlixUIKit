//
//  UpcomingViewController.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import UIKit

class UpcomingViewController: UIViewController{
    static let title: String = "Upcoming"
    
    private var shows: [Show] = []
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = UpcomingViewController.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchShows()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchShows(){
        HomeFeedSection.upcomingMovies.getShows { [weak self] result in
            switch result{
            case .success(let shows): if let self{
                    DispatchQueue.main.async {
                        self.shows = shows
                        self.tableView.reloadData()
                    }
                }
            case .failure: break
            }
        }
    }
    
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ShowTableViewCell.identifier, for: indexPath) as? ShowTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: .get(from: shows[indexPath.row]))
        
        return cell
    }
}

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
//        button.setTitle("Play", for: .normal)
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
