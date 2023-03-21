import UIKit

protocol CoordinatorProtocol {
    func start(scene: SceneStatus)
    func ivent(action: ActionType, iniciator: UIViewController)
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
    case openPost(id: String)
    case loginSuccess
    case showProfile(userId: String)
}
