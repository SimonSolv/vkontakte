import UIKit

class AppCoordinator: CoordinatorProtocol {

    
    private let tabBarController: UITabBarController
    private let factory: Factory
    var notificationService: LocalNotificationService?

    init(tabBarController: UITabBarController, factory: Factory) {
        self.tabBarController = tabBarController
        tabBarController.tabBar.backgroundColor = .clear
        tabBarController.view.backgroundColor = .white
        self.factory = factory
    }

    func start() {
        // Create and add view controllers for each tab
        let newsViewController = factory.createController(type: .feed, coordinator: self)
        let profileViewController = factory.createController(type: .profile, coordinator: self)
        let likedViewController = factory.createController(type: .liked, coordinator: self)
        tabBarController.viewControllers = [newsViewController, profileViewController, likedViewController]

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
        case .registerSuccess:
            let generalInfoViewController = factory.createController(type: .generalInfo, coordinator: self)
            iniciator.navigationController?.pushViewController(generalInfoViewController, animated: true)
        case .requestNotifications:
            notificationService?.registeForLatestUpdatesIfPossible()
        case .sendNotification:
            notificationService?.registerNotificationTimeInterval(title: "VerificationCode", body: "Your verification code is: 0000", interval: 2)
        case .openPost:
            let controller = factory.createController(type: .post, coordinator: self)
            iniciator.navigationController?.pushViewController(controller, animated: true)
        }
    }

}




