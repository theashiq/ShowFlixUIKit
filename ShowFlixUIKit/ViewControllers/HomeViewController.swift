//
//  HomeViewController.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import UIKit

class HomeViewController: UIViewController{
    static let title: String = "Home"
    
    private let sections: [ShowFeedType] = [.trendingMovies, .popular, .trendingTV, .upcomingMovies, .topRated]
    private var allSectionShows: [ShowFeedType: [Show]] = [:]
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.tableHeaderView = HomeHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        
        addNavBar()
    }
    
    private func addNavBar(){
        let size = CGSize(width: 50, height: 50)
        let renderer = UIGraphicsImageRenderer(size: size)
        let logoImage = renderer.image { _ in
            UIImage.logo.draw(in: CGRect.init(origin: CGPoint.zero, size: size))
        }.withRenderingMode(.alwaysOriginal)
        
        let logoBarButton = UIBarButtonItem(image: logoImage, style: .done, target: self, action: nil)
        
        navigationItem.leftBarButtonItem = logoBarButton
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "play.square"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .label
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = view.safeAreaInsets.top + scrollView.contentOffset.y
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}


extension HomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        if let sectionShows = allSectionShows[sections[indexPath.section]]{
            cell.configure(with: sectionShows)
        }
        else{
            sections[indexPath.section].getShows { [weak self] result in
                switch result{
                case .success(let shows): if let self{
                        DispatchQueue.main.async {
                            self.allSectionShows[self.sections[indexPath.section]] = shows
                            cell.configure(with: shows)
                        }
                    }
                case .failure(let error): 
                    DispatchQueue.main.async {
                        cell.configure(with: error)
                    }
                }
            }
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        
        header.textLabel?.font.withSize(18)
        header.textLabel?.textColor = .label
    }
}


extension HomeViewController: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, show: Show) {
        ShowPreviewViewController.preview(for: show, from: self)
    }
}
