import UIKit

enum ControllerType {
    case feed
    case profile(user: UserData)
    case liked
    case landing
    case registration
    case confirmation
    case generalInfo
    case post(source: Post)
    case login
    case additionalInfo(user: UserData)
    case createPost
    case profileContainer(user: UserData)
    case editProfile
    case settings
}

protocol FactoryProtocol {
    func createController(type: ControllerType, coordinator: CoordinatorProtocol) -> UIViewController
}

class Factory: FactoryProtocol {
    func createController(type: ControllerType, coordinator: CoordinatorProtocol) -> UIViewController {
        switch type {
        case .feed:
            let controller = FeedViewController()
            controller.coordinator = coordinator
            controller.tabBarItem = UITabBarItem(title: "News", image: UIImage(systemName: "book.fill"), tag: 0)
            return controller
        case .profile(let user):
            let controller = ProfileViewController(user: user)
            controller.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
            controller.coordinator = coordinator
            return controller
        case .liked:
            let controller = LikedViewController()
            controller.tabBarItem = UITabBarItem(title: "Liked", image: UIImage(systemName: "heart.fill"), tag: 2)
            controller.coordinator = coordinator
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
        case .post(let post):
            let controller = PostViewController()
            controller.post = post
            controller.coordinator = coordinator
            return controller
        case .login:
            let controller = LoginViewController()
            controller.coordinator = coordinator
            controller.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
            return controller
        case .additionalInfo(let user):
            let controller = AdditionalInfoViewController()
            controller.user = user
            controller.coordinator = coordinator
            return controller
        case .createPost:
            let controller = CreatePostViewController()
            controller.coordinator = coordinator
            return controller
        case .profileContainer(let user):
            let containerVC = ContainerViewController()
            containerVC.coordinator = coordinator
            containerVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 1)
            let sideVC = SideMenuViewController()
            sideVC.delegate = containerVC
            let profileViewController = self.createController(type: .profile(user: user), coordinator: coordinator) as? ProfileViewController
            containerVC.profileVC = profileViewController
            containerVC.sideMenuVC = sideVC
            return containerVC
        case .editProfile:
            let controller = EditProfileViewController()
            controller.coordinator = coordinator
            return controller
        case .settings:
            let controller = SettingsViewController()
            controller.coordinator = coordinator
            return controller
        }
    }
}
