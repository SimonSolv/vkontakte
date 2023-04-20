import UIKit

protocol CoordinatorProtocol {
    func start(scene: SceneStatus)
    func ivent(action: ActionType, iniciator: UIViewController)
    func setTabTo(tab: AppTab)
}

protocol CoordinatedProtocol {
    var coordinator: CoordinatorProtocol? { get set }
}

enum ActionType {
    case showRegisterPage
    case showRegistrationConfirmation
    case addGeneralInfo
    case requestNotifications
    case sendNotification
    case openPost(post: Post)
    case loginSuccess(user: UserData)
    case showProfile(user: UserData)
    case showAdditionalInfo(user: UserData)
    case hasAccount
    case messageTapped
    case createPostTapped
    case editProfileTapped
    case openSettings
}

enum AppTab {
    case profile
    case feed
    case liked
}


class AppCoordinator: CoordinatorProtocol {
    
    private let tabBarController: UITabBarController
    private let factory: Factory
    var notificationService: LocalNotificationManager?
    let coreManager = CoreDataManager.shared

    init(tabBarController: UITabBarController, factory: Factory) {
        self.tabBarController = tabBarController
        tabBarController.view.backgroundColor = .white
        tabBarController.tabBar.tintColor = .orange
        tabBarController.tabBar.backgroundColor = .white
        self.factory = factory
    }

    func start(scene: SceneStatus) {
        // Create and add view controllers for each tab
        let newsViewController = factory.createController(type: .feed, coordinator: self)
        
        let feedNavVc = UINavigationController(rootViewController: newsViewController)

        let likedViewController = factory.createController(type: .liked, coordinator: self)
        let likesNavVc = UINavigationController(rootViewController: likedViewController)
        switch scene {
        case .firstTime:
            let landing = factory.createController(type: .landing, coordinator: self)
            tabBarController.viewControllers = [feedNavVc, landing, likesNavVc]
            tabBarController.selectedIndex = 1
            tabBarController.tabBar.isHidden = true
        case .logged:
            let containerVC = factory.createController(type: .profileContainer(user: coreManager.currentUser!), coordinator: self)
            tabBarController.viewControllers = [feedNavVc, containerVC, likesNavVc]
        case .unlogged:
            let loginViewController = factory.createController(type: .login, coordinator: self)
            let loginNavVc = UINavigationController(rootViewController: loginViewController)
            tabBarController.viewControllers = [feedNavVc, loginNavVc, likesNavVc]
            tabBarController.selectedIndex = 1
        }
    }

    // Implement methods for navigating between screens
    
    func ivent(action: ActionType, iniciator: UIViewController) {
        switch action {
        case .showRegisterPage:
            let registerViewController = factory.createController(type: .registration, coordinator: self)
            iniciator.navigationController?.pushViewController(registerViewController, animated: true)
        case .showRegistrationConfirmation:
            let confirmationViewController = factory.createController(type: .confirmation, coordinator: self)
            iniciator.navigationController?.pushViewController(confirmationViewController, animated: true)
        case .addGeneralInfo:
            let generalInfoViewController = factory.createController(type: .generalInfo, coordinator: self)
            iniciator.navigationController?.pushViewController(generalInfoViewController, animated: true)
        case .requestNotifications:
            notificationService?.registeForLatestUpdatesIfPossible()
        case .sendNotification:
            notificationService?.registerNotificationTimeInterval(title: "VerificationCode", body: "Your verification code is: 0000", interval: 2)
        case .openPost(let post):
            let controller = factory.createController(type: .post(source: post), coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .loginSuccess(let user):
            let controller = factory.createController(type: .profileContainer(user: user), coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
            self.tabBarController.tabBar.isHidden = false
        case .showProfile(let user):
            if user.isLogged == true {
                setTabTo(tab: .profile)
            } else {
                let controller = factory.createController(type: .profile(user: user), coordinator: self)
                iniciator.navigationController?.pushViewController(controller, animated: true)
            }
        case .showAdditionalInfo(let user):
            let controller = factory.createController(type: .additionalInfo(user: user), coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .hasAccount:
            let controller = factory.createController(type: .login, coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .messageTapped:
            print("Sending message")
        case .createPostTapped:
            let controller = factory.createController(type: .createPost, coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .openSettings:
            let controller = factory.createController(type: .settings, coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .editProfileTapped:
            let controller = factory.createController(type: .editProfile, coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func setTabTo(tab: AppTab) {
        switch tab {
        case .liked:
            self.tabBarController.selectedIndex = 2
        case .feed:
            self.tabBarController.selectedIndex = 0
        case .profile:
            self.tabBarController.selectedIndex = 1
        }
    }

}




