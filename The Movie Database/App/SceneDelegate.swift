//
//  SceneDelegate.swift
//  The Movie Database
//
//  Created by NIKITA on 17.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var mainCoordinator: MainCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        mainCoordinator = MainCoordinator()
        mainCoordinator?.start(with: window)
    }
}
