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
        let vc4 = UINavigationController(rootViewController: SecondViewController())
    
        setViewControllers([vc3, vc1, vc2, vc4], animated: true)
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "play.circle")
        vc3.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        vc4.tabBarItem.image = UIImage(systemName: "arrow.down.to.line")
        
        vc1.title = HomeViewController.title
        vc2.title = UpcomingViewController.title
        vc3.title = SearchViewController.title
        vc4.title = SecondViewController.title
        
        tabBar.tintColor = .label
        tabBar.backgroundColor = .secondarySystemBackground
    }
}

class SecondViewController: UIViewController{
    static let title: String = "Second View"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        let label = UILabel(frame: view.bounds)
        label.text = "Second View"
        label.font = .systemFont(ofSize: 50, weight: .heavy)
        label.textAlignment = .center
        view.addSubview(label)
    }
}



