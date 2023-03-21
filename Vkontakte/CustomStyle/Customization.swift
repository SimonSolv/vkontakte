import UIKit

enum ButtonStyle {
    case main
    case action
    case orangeish
    case line
}

enum TextFieldStyle {
    case phoneField
    case login
    case subGeneral
    case notFilled
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
        case .orangeish:
            self.backgroundColor = .orange
            self.layer.cornerRadius = 15
            self.titleLabel?.font = .systemFont(ofSize: 20)
            self.setTitleColor(.white, for: .normal)
        case .line:
            self.setTitleColor(.gray, for: .normal)
            self.titleLabel?.font = .systemFont(ofSize: 15)
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

final class CustomButton: UIButton {
    private var onTap: () -> Void

    init(title: String, titleColor: UIColor, onTap: @escaping () -> Void) {
        self.onTap = onTap
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        nil
    }
    @objc private func buttonTapped() {
        self.onTap()
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
        case .notFilled:
            self.layer.borderColor = UIColor.red.cgColor
        case .login:
            self.backgroundColor = .systemGray6
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.font = .systemFont(ofSize: 16)
            self.textColor = .black
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always
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

enum UIImageViewStyle {
    case avatar
}

extension UIImageView {
    func setCustomStyle(style: UIImageViewStyle) {
        switch style {
        case .avatar:
            self.layer.cornerRadius = 30
            self.clipsToBounds = true
            self.contentMode = .scaleAspectFill
        }
    }
}
