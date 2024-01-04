//
//  WatchListViewController.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/3/24.
//
import UIKit

class WatchListViewController: UIViewController{
    static let title: String = "Watchlist"
    private var shows: [Show] = []
    
    private var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(WatchListItemTableViewCell.self, forCellReuseIdentifier: WatchListItemTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = WatchListViewController.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(PersistenceManager.notificationId), object: nil, queue: nil) {[weak self] _ in
            self?.fetchWatchListItems()
        }
    }
    
    func fetchWatchListItems(){
        DispatchQueue.main.async { [weak self] in
            self?.shows = PersistenceManager.shared.watchListedShows
            
            let savedIndex = self?.tableView.indexPathsForVisibleRows?.first
            self?.tableView.reloadData()

            if let savedIndex, savedIndex.row < self?.shows.count ?? 0{
                self?.tableView.scrollToRow(at: savedIndex, at: .top, animated: true)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWatchListItems()
    }
}

extension WatchListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: WatchListItemTableViewCell.identifier, for: indexPath) as? WatchListItemTableViewCell else {
            return UITableViewCell()
        }
        
        let show = shows[indexPath.row]
        var showVM: ShowViewModel = .get(from: show)
        showVM.wishListItem = PersistenceManager.shared.isAddedToWatchList(show: show)
        cell.configure(with: showVM)
        return cell
    }
        
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
        
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            PersistenceManager.shared.removeFromWatchList(show: shows[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    self?.shows.remove(at: indexPath.row)
                    self?.tableView.deleteRows(at: [indexPath], with: .fade)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            }
        }
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ShowPreviewViewController.preview(for: shows[indexPath.row], from: self)
    }
     
}
