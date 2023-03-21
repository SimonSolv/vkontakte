import UIKit

class AppCoordinator: CoordinatorProtocol {

    
    private let tabBarController: UITabBarController
    private let factory: Factory
    var notificationService: LocalNotificationManager?

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
        feedNavVc.navigationBar.isHidden = true

        let likedViewController = factory.createController(type: .liked, coordinator: self)
        switch scene {
        case .firstTime:
            let landing = factory.createController(type: .landing, coordinator: self)
            tabBarController.viewControllers = [feedNavVc, landing, likedViewController]
            tabBarController.selectedIndex = 1
            tabBarController.tabBar.isHidden = true
        case .logged:
            let profileViewController = factory.createController(type: .profile(userId: CoreDataManager.shared.getUserByName(name: "Kate")!.id!), coordinator: self)
            let profileNavVc = UINavigationController(rootViewController: profileViewController)
            profileNavVc.navigationBar.isHidden = true
            tabBarController.viewControllers = [feedNavVc, profileNavVc, likedViewController]
        case .unlogged:
            let loginViewController = factory.createController(type: .login, coordinator: self)
            let loginNavVc = UINavigationController(rootViewController: loginViewController)
            tabBarController.viewControllers = [feedNavVc, loginNavVc, likedViewController]
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
        case .openPost(let id):
            let controller = factory.createController(type: .post(id: id), coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        case .loginSuccess:
            let controller = factory.createController(type: .profile(userId: (CoreDataManager.shared.currentUser?.id)!), coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
            self.tabBarController.tabBar.isHidden = false
        case .showProfile(let userId):
            let controller = factory.createController(type: .profile(userId: userId), coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        }
    }

}




