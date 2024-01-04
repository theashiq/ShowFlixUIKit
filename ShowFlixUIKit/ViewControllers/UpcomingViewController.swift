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
        ShowFeedType.upcomingMovies.getShows { [weak self] result in
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
    private func reloadTableCell(for show: Show){
        if let index = shows.indices.first(where: { shows[$0] == show}){
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
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
        
        let show = shows[indexPath.row]
        var showVM: ShowViewModel = .get(from: show)
        showVM.wishListItem = PersistenceManager.shared.isAddedToWatchList(show: show)
        cell.configure(with: showVM)
        cell.delegate = self
        
        return cell
    }
}

extension UpcomingViewController: ShowTableViewCellDelegate{
    func watchListButtonDidTap(_ show: Show, cell: ShowTableViewCell) {
        
        if PersistenceManager.shared.isAddedToWatchList(show: show){
            PersistenceManager.shared.removeFromWatchList(show: show){ [weak self] result in
                switch result{
                case .success(()): self?.reloadTableCell(for: show)
                case .failure(let error): print(error.localizedDescription)
                }
            }
        }
        else{
            PersistenceManager.shared.addToWatchList(show: show) { [weak self] result in
                switch result{
                case .success(()): self?.reloadTableCell(for: show)
                case .failure(let error): print(error.localizedDescription)
                }
            }
        }
    }
}

