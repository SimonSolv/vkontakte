import UIKit

enum ButtonStyle {
    case main
    case action
    case plain
}

enum TextFieldStyle {
    case phoneField
    case other
    case subGeneral
}

enum LabelStyle {
    case title
    case subtitle
    case grayBig
    case grayMedium
    case miniTitle
    case feedTitle
    case feedBody
}

extension UIButton {
    func setCustomStyle(style: ButtonStyle) {
        switch style {
        case .main:
            self.backgroundColor = .systemGray
            self.layer.cornerRadius = 15
        case .action:
            self.backgroundColor = .systemBlue
            self.layer.cornerRadius = 15
        case .plain:
            self.backgroundColor = .systemMint
            self.layer.cornerRadius = 15
        }
    }
    
    func makeEnable() {
        self.isEnabled = true
        self.layer.backgroundColor = UIColor.systemGreen.cgColor
    }
    
    func makeDisable() {
        self.isEnabled = false
        self.layer.backgroundColor = UIColor.systemGray.cgColor
    }
}

extension UITextField {
    func setCustomStyle(_ style: TextFieldStyle) {
        switch style {
        case .phoneField:
            self.layer.borderColor = UIColor.systemGray3.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 15
            self.layer.backgroundColor = UIColor.white.cgColor
            self.font = UIFont.boldSystemFont(ofSize: 25)
            self.keyboardType = .phonePad
            self.textColor = .black
        case .subGeneral:
            self.layer.borderColor = UIColor.systemGray3.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 15
            self.layer.backgroundColor = UIColor.white.cgColor
            self.font = UIFont.boldSystemFont(ofSize: 18)
            self.keyboardType = .default
            self.textColor = .black
            self.addLeftPadding(10)
        case .other:
            self.layer.backgroundColor = UIColor.systemGreen.cgColor
        }
    }

    func addLeftPadding(_ padding: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}

extension UILabel {
    func setCustomStyle(style: LabelStyle) {
        switch style {
        case .title:
            self.font = UIFont.boldSystemFont(ofSize: 25)
            self.textColor = .black
            self.textAlignment = .center
        case .subtitle:
            self.font = UIFont.systemFont(ofSize: 20)
            self.textAlignment = .center
            self.textColor = .black
        case .grayBig:
            self.font = UIFont.boldSystemFont(ofSize: 20)
            self.textColor = .systemGray3
            self.textAlignment = .center
        case .grayMedium:
            self.font = UIFont.boldSystemFont(ofSize: 15)
            self.textColor = .systemGray3
            self.textAlignment = .center
        case .miniTitle:
            self.font = UIFont.systemFont(ofSize: 10)
            self.textColor = .systemGray
            self.textAlignment = .center
        case .feedTitle:
            self.font = UIFont.boldSystemFont(ofSize: 20)
            self.textColor = .black
            self.textAlignment = .left
        case .feedBody:
            self.font = UIFont.systemFont(ofSize: 15)
            self.textColor = .black
            self.textAlignment = .left
        }
    }
}
