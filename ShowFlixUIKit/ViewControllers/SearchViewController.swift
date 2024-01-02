//
//  SearchViewController.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/3/24.
//

import UIKit

class SearchViewController: UIViewController{
    static let title: String = "Search"
    
    private var shows: [Show] = []
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(ShowTableViewCell.self, forCellReuseIdentifier: ShowTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = SearchViewController.title
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
        ShowFeedType.discover.getShows { [weak self] result in
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

extension SearchViewController: UITableViewDelegate, UITableViewDataSource{
    
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
