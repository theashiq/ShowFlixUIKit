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
    
    private var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or a TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
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
        
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .label
        searchController.searchResultsUpdater = self
        
        fetchDiscoverShows()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func fetchDiscoverShows(){
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
    
    private func reloadTableCell(for show: Show){
        if let index = shows.indices.first(where: { shows[$0] == show}){
            tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
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
        
        let show = shows[indexPath.row]
        var showVM: ShowViewModel = .get(from: show)
        showVM.wishListItem = PersistenceManager.shared.isAddedToWatchList(show: show)
        cell.configure(with: showVM)
        cell.delegate = self
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ShowPreviewViewController.preview(for: shows[indexPath.row], from: self)
        PersistenceManager.shared.addToWatchList(show: shows[indexPath.row]) { result in
            print(result)
        }
    }
}

extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
                
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces),
              query.count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
              }
        
        resultsController.delegate = self
        
        ShowFeedType.search(query).getShows { result in
            switch result{
            case .success(let shows):
                    DispatchQueue.main.async {
                        resultsController.configure(with: shows)
                    }
                
            case .failure(let error):
                DispatchQueue.main.async {
                    resultsController.configure(with: error)
                }
            }
        }
    }
}

extension SearchViewController: SearchResultsCellDelegate{
    func searchResultsCellDidTapCell(show: Show) {
        ShowPreviewViewController.preview(for: show, from: self)
    }
}

extension SearchViewController: ShowTableViewCellDelegate{
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

