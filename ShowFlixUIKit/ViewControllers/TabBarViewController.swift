//
//  TabBarViewController.swift
//  ShowFlixUIKit
//
//  Created by mac 2019 on 1/2/24.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let vc1 = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: UpcomingViewController())
        let vc3 = UINavigationController(rootViewController: SearchViewController())
        let vc4 = UINavigationController(rootViewController: WatchListViewController())
    
        setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        
        vc1.tabBarItem = UITabBarItem(title: HomeViewController.title, image: UIImage(systemName: "house"), tag: 0)
        vc2.tabBarItem = UITabBarItem(title: UpcomingViewController.title, image: UIImage(systemName: "play.circle"), tag: 1)
        vc3.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 2)
        vc4.tabBarItem = UITabBarItem(title: WatchListViewController.title, image: UIImage(systemName: "list.and.film"), tag: 3)
        
        tabBar.tintColor = .label
        tabBar.backgroundColor = .secondarySystemBackground
    }
    
    override func viewWillAppear(_ animated: Bool) {
        _ = PersistenceManager.shared
    }
}


