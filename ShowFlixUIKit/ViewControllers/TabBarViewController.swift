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
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let vc2 = UINavigationController(rootViewController: SecondViewController())
    
        setViewControllers([homeVC, vc2], animated: true)
        
        homeVC.title = HomeViewController.title
        vc2.title = SecondViewController.title
        
        homeVC.tabBarItem.image = UIImage(systemName: "house.fill")
        vc2.tabBarItem.image = UIImage(systemName: "2.circle.fill")
        
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
