//
//  SceneDelegate.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    let coreManager = CoreDataManager.shared
    
    let hasCreatedPostsKey = "hasCreatedPosts"

    var notificationService: LocalNotificationManager?
    
    func getSceneStatus() -> SceneStatus {
        var state: SceneStatus = .unlogged
        for user in coreManager.users {
            if user.isLogged == true {
                state = .logged
                break
            } else {
                state = .unlogged
            }
        }
        return state
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Instantiate a tabBar controller and a tab factory
        let tabBarController = UITabBarController()
        let factory = Factory()
        coreManager.getCurrentUser()
        
        let isDarkModeEnabled = UserDefaults.standard.bool(forKey: "isDarkModeEnabled")
        
        if isDarkModeEnabled {
            window?.overrideUserInterfaceStyle = .dark
        } else {
            window?.overrideUserInterfaceStyle = .light
        }
        // Instantiate a coordinator with the tab bar controller and tab factory
        let appCoordinator = AppCoordinator(tabBarController: tabBarController, factory: factory)
        appCoordinator.notificationService = notificationService
        
        let window = UIWindow(windowScene: windowScene)
        
        // Define scene to connect
        var sceneStatus: SceneStatus = .logged
        
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: hasCreatedPostsKey) {
            sceneStatus = .firstTime
            let filler = DataFiller()
            filler.createUsers()
            filler.createPosts()
 //           sceneStatus = .logged
            userDefaults.set(true, forKey: hasCreatedPostsKey)
        } else {
            sceneStatus = getSceneStatus()
        }
        self.window = window
        window.rootViewController = tabBarController
        appCoordinator.start(scene: sceneStatus)
        window.makeKeyAndVisible()
    }
   
        
    func sceneDidEnterBackground(_ scene: UIScene) {

        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        let currentTheme = UIApplication.shared.windows.first?.rootViewController?.traitCollection.userInterfaceStyle ?? .light

        UserDefaults.standard.set(window?.traitCollection.userInterfaceStyle == currentTheme, forKey: "isDarkModeEnabled")
    }

}

enum SceneStatus {
    case firstTime
    case logged
    case unlogged
}

