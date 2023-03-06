//
//  SceneDelegate.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var notificationService: LocalNotificationService?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        notificationService = LocalNotificationService()
        
        // Instantiate a tabBar controller and a tab factory
        
        let tabBarController = UITabBarController()
        let factory = Factory()
        
        // Instantiate a coordinator with the tab bar controller and tab factory
        
        let appCoordinator = AppCoordinator(tabBarController: tabBarController, factory: factory)
        appCoordinator.notificationService = notificationService
        let authStatus = true
        let window = UIWindow(windowScene: windowScene)
        
        if authStatus {

            // Set the root view controller to the tabBar controller
            window.rootViewController = tabBarController

            // Start the coordinator
            appCoordinator.start()
            
        } else {
            let viewController = factory.createController(type: .landing, coordinator: appCoordinator)
            
            // Set the root view controller to the tabBar controller
            window.rootViewController = viewController

        }
        self.window = window
        window.makeKeyAndVisible()

    }
    
    func showMainScene() {
        guard let windowScene = (self.window?.windowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        notificationService = LocalNotificationService()
        
        // Instantiate a tabBar controller and a tab factory
        
        let tabBarController = UITabBarController()
        let factory = Factory()
        
        // Instantiate a coordinator with the tab bar controller and tab factory
        
        let appCoordinator = AppCoordinator(tabBarController: tabBarController, factory: factory)
        appCoordinator.notificationService = notificationService
        
        window.rootViewController = tabBarController
        appCoordinator.start()
        window.makeKeyAndVisible()
        self.window = window
    }
    

    func sceneDidEnterBackground(_ scene: UIScene) {

        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

