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
    
    let hasCreatedPostsKey = "hasCreatedPosts"

    var notificationService: LocalNotificationManager?
    
    func getSceneStatus() -> SceneStatus {
        return .logged
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Instantiate a tabBar controller and a tab factory
        let tabBarController = UITabBarController()
        let factory = Factory()
        
        // Instantiate a coordinator with the tab bar controller and tab factory
        let appCoordinator = AppCoordinator(tabBarController: tabBarController, factory: factory)
        appCoordinator.notificationService = notificationService
        
        let window = UIWindow(windowScene: windowScene)
        
        // Define scene to connect
        let sceneStatus = getSceneStatus()
        
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: hasCreatedPostsKey) {
            createUsers()
            createPosts()
            userDefaults.set(true, forKey: hasCreatedPostsKey)
        }
        
        switch sceneStatus {
        case .firstTimeUnlogged:
            notificationService = LocalNotificationManager()
            let viewController = factory.createController(type: .landing, coordinator: appCoordinator)
            
            // Set the root view controller to the tabBar controller
            window.rootViewController = viewController
            
            self.window = window
            window.makeKeyAndVisible()
        case .notFirstTimeUnlogged:
            notificationService = LocalNotificationManager()
            let viewController = factory.createController(type: .landing, coordinator: appCoordinator)
            
            // Set the root view controller to the tabBar controller
            window.rootViewController = viewController
            
            self.window = window
            window.makeKeyAndVisible()
        case .logged:
            // Set the root view controller to the tabBar controller
            window.rootViewController = tabBarController

            // Start the coordinator
            appCoordinator.start()
            
            self.window = window
            window.makeKeyAndVisible()
        case .unlogged:
            
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func showMainScene() {
        guard let windowScene = (self.window?.windowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        notificationService = LocalNotificationManager()
        
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

    func createUsers() {
        let coreManager = CoreDataManager.shared
        var name = "Leonardo"
        var lastName = "Dicaprio"
        var jobTitle = "Actor"
        var avatar = "LeoAvatar"
        var nickName = "leoDicaprio"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatar)
        name = "Kate"
        lastName = "Winslet"
        jobTitle = "Actor"
        avatar = "KateAvatar"
        nickName = "kateTitanic"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatar)
        name = "Selena"
        lastName = "Gomez"
        jobTitle = "Singer"
        avatar = "SelenaAvatar"
        nickName = "ssselllenn"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatar)
        name = "Mark"
        lastName = "Wohlberg"
        jobTitle = "Actor"
        avatar = "MarkAvatar"
        nickName = "markovnik"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatar)
        name = "Michael"
        lastName = "Jackson"
        jobTitle = "Singer"
        avatar = "KateAvatar"
        nickName = "mihailPevets"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatar)
        name = "Peter"
        lastName = "Jackson"
        jobTitle = "Produsser"
        avatar = "PeterAvatar"
        nickName = "hobbit"
        coreManager.createUser(name: name, lastName: lastName, jobTitle: jobTitle, nickName: nickName, dateOfBirth: Date(), avatar: avatar)
    }
    
    func createPosts() {
        
        let coreManager = CoreDataManager.shared
        var body = "Второй сезон сериала Amazon Studios «Властелин колец: Кольца власти» снимет полностью женская команда режиссеров. Об этом сообщает Deadline.\nНад новыми сериями будут работать Шарлотта Брандстром, Сана Хамри и Луиза Хупер. Второй сезон будет состоять из восьми эпизодов.\nОтмечается, что Брандстром уже занималась над двумя сериями первого сезона. В этот раз она будет задействована при создании четырех эпизодов, а также выступит исполнительным продюсером шоу. Ее коллеги снимут по две серии проекта.\nВ октябре сообщалось, что в Великобритании стартовали съемки второго сезона сериала «Властелин колец: Кольца власти». В главных ролях выступят Синтия Аддай-Робинсон, Роберт Арамайо, Оуайн Артур, Максим Болдри, Назанин Бониади, Морвед Кларк, Исмаэль Крус Кордова, Чарльз Эдвардс, Тристан Гравель, сэр Ленни Генри, Эма Хорват.\nДействие сериала «Властелин колец: Кольца власти» происходит за тысячи лет до событий, упомянутых в фильмах режиссера Питера Джексона. Первый сезон снимался в Новой Зеландии, съемки второго были перенесены в Великобританию для экономии и удобства."
        var title = "Второй сезон «Властелин колец: Кольца власти» снимет полностью женская команда"
        var author = coreManager.getUserByName(name: "Peter")
        var image = "PostImage0"
        coreManager.createPost(title: title, body: body, image: image, authorId: (author?.id)!)
        title = "Тайны длиной в 25 лет: раскрыты факты о фильме «Титаник»"
        body = "Например, Джек в исполнении ДиКаприо совершенно рисовать не умел. Все наброски, Роуз в том числе, делал режисер Джеймс Кэмерон. При этом, чтобы создать иллюзию рисования Джеком, картину пришлось перевернуть на монтаже, ведь Леонардо ДиКаприо — левша, а Кэмерон — правша.\nОстов затонувшего корабля под водой был самым настоящим, а не смонтированным. Режисер спускался под воду, где провел 15-17 часов, делая фотографии судна со всех возможных ракурсов.\nА знаменитой песни в конце могло и не быть вовсе. Кэмерон изначально хотел добавить лишь фоновую мелодию, но Джеймс Хорнер тайно договорился с Селин Дион о демо-записи композиции My Heart Will Go On. После прослушивания режисер устоять перед голосом исполнительницы не смог, а фильм обрел легендарный саундтрек — об этом сообщает The Voice."
        author = coreManager.getUserByName(name: "Kate")
        image =  "PostImage2"
        coreManager.createPost(title: title, body: body, image: image, authorId: (author?.id)!)
    }

}

enum SceneStatus {
    case firstTimeUnlogged
    case notFirstTimeUnlogged
    case logged
    case unlogged
}

