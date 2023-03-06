import UIKit

protocol CoordinatorProtocol {
    func start()
    func ivent(action: ActionType, iniciator: UIViewController)
}

protocol CoordinatedProtocol {
    var coordinator: CoordinatorProtocol? { get set }
}

enum ActionType {
    case showRegisterPage
    case showRegistrationConfirmation
    case registerSuccess
    case requestNotifications
    case sendNotification
    case openPost
}
