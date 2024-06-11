//
//  AppDelegate.swift
//  The Movie Database
//
//  Created by NIKITA on 17.05.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start(with: window)
        window?.makeKeyAndVisible()
        return true
    }
}
