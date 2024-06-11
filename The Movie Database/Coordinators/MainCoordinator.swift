//
//  MainCoordinator.swift
//  The Movie Database
//
//  Created by NIKITA on 21.05.2024.
//


import UIKit

class MainCoordinator: NSObject, UITabBarControllerDelegate {
    var tabBarController: UITabBarController?

    func start(with window: UIWindow?) {
        let tabBarController = UITabBarController()
        tabBarController.delegate = self

        let popularVC = PopularViewController()
        let popularNav = UINavigationController(rootViewController: popularVC)
        popularNav.tabBarItem = UITabBarItem(title: "Popular", image: UIImage(systemName: "star"), tag: 0)

        let watchLaterVC = WatchLaterViewController()
        let watchLaterNav = UINavigationController(rootViewController: watchLaterVC)
        watchLaterNav.tabBarItem = UITabBarItem(title: "Watch Later", image: UIImage(systemName: "clock"), tag: 1)

        tabBarController.viewControllers = [popularNav, watchLaterNav]
        self.tabBarController = tabBarController
       
        tabBarController.tabBar.backgroundColor = .black
        tabBarController.tabBar.tintColor = .white
        tabBarController.tabBar.unselectedItemTintColor = UIColor(white: 0.4, alpha: 1.0)
        
        if let window = window {
            window.rootViewController = tabBarController
            window.makeKeyAndVisible()
        }
    }
}
