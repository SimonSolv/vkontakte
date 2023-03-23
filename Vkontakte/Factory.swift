import UIKit

enum ControllerType {
    case feed
    case profile(id: String)
    case liked
    case landing
    case registration
    case confirmation
    case generalInfo
    case post(id: String)
    case login
    case additionalInfo(id: String)
}

class Factory: FactoryProtocol {
    func createController(type: ControllerType, coordinator: CoordinatorProtocol) -> UIViewController {
        switch type {
        case .feed:
            let controller = FeedViewController()
            controller.coordinator = coordinator
            controller.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "book.fill"), tag: 0)
            return controller
        case .profile(let id):
            let controller = ProfileViewController(userId: id)
            controller.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
            return controller
        case .liked:
            let controller = UIViewController()
            controller.tabBarItem = UITabBarItem(title: "Liked", image: UIImage(systemName: "heart.fill"), tag: 2)
            controller.view.backgroundColor = .orange
            return controller
        case .confirmation:
            let controller = ConfirmationViewController()
            controller.coordinator = coordinator
            return controller
        case .landing:
            let controller = LandingViewController()
            controller.coordinator = coordinator
            controller.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
            let navController = UINavigationController(rootViewController: controller)
            return navController
        case .registration:
            let controller = RegisterViewController()
            controller.coordinator = coordinator
            return controller
        case .generalInfo:
            let controller = GeneralInfoViewController()
            controller.coordinator = coordinator
            return controller
        case .post(let id):
            let controller = PostViewController()
            controller.postId = id
            controller.coordinator = coordinator
            return controller
        case .login:
            let controller = LoginViewController()
            controller.coordinator = coordinator
            controller.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
            return controller
        case .additionalInfo(let id):
            let controller = AdditionalInfoViewController()
            controller.userId = id
            controller.coordinator = coordinator
            return controller
        }
    }
}
