//
//  SceneDelegate.swift
//  ToDoListYandex
//
//  Created by Anastasia Sharapenko on 6/13/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        let controller = TasksListViewController()
        let navController = UINavigationController(rootViewController: controller)
        window.rootViewController = navController
        self.window = window
        window.makeKeyAndVisible()
    }
}
