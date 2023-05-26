import UIKit

class CustomAlert {
    static func showAlert(title: String, message: String, okActionTitle: String, okActionHandler: (() -> Void)? = nil, additionalActionTitle: String? = nil, additionalActionHandler: (() -> Void)? = nil, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add the "OK" action
        let okAction = UIAlertAction(title: okActionTitle, style: .default) { _ in
            okActionHandler?()
        }
        alertController.addAction(okAction)
        
        // Add the additional action if provided
        if let additionalActionTitle = additionalActionTitle {
            let additionalAction = UIAlertAction(title: additionalActionTitle, style: .default) { _ in
                additionalActionHandler?()
            }
            alertController.addAction(additionalAction)
        }
        
        // Present the alert controller
        viewController.present(alertController, animated: true, completion: nil)
    }
}


