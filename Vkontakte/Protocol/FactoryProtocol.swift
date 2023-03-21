import UIKit

protocol FactoryProtocol {
    func createController(type: ControllerType, coordinator: CoordinatorProtocol) -> UIViewController
}
