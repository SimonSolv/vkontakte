import UIKit

class AppCoordinator: CoordinatorProtocol {

    enum AppTab {
        case profile
        case feed
        case liked
    }
    
    private let tabBarController: UITabBarController
    private let factory: Factory
    var notificationService: LocalNotificationManager?
    let coreManager = CoreDataManager.shared
    var currentUser: UserData?

    init(tabBarController: UITabBarController, factory: Factory) {
        self.tabBarController = tabBarController
        tabBarController.tabBar.backgroundColor = .clear
        tabBarController.view.backgroundColor = .white
        tabBarController.tabBar.tintColor = .orange
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
            currentUser = coreManager.getCurrentUser()
            let profileViewController = factory.createController(type: .profile(id: (currentUser?.id)!), coordinator: self)
            let profileNavVc = UINavigationController(rootViewController: profileViewController)
            profileNavVc.navigationBar.isHidden = true
            tabBarController.viewControllers = [feedNavVc, profileNavVc, likesNavVc]
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
        case .loginSuccess(let id):
            let controller = factory.createController(type: .profile(id: id), coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
            self.tabBarController.tabBar.isHidden = false
        case .showProfile(let userId):
            let currentUser = coreManager.getUser(id: userId)
            if currentUser?.isLogged == true {
                setTabTo(tab: .profile)
            } else {
                let controller = factory.createController(type: .profile(id: userId), coordinator: self)
                iniciator.navigationController?.pushViewController(controller, animated: true)
            }
        case .showAdditionalInfo(let id):
            let controller = factory.createController(type: .additionalInfo(id: id), coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .hasAccount:
            let controller = factory.createController(type: .login, coordinator: self)
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




