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
    case plain
}

enum TextViewStyle {
    case plain
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
            self.backgroundColor = .systemGray2
            self.layer.cornerRadius = 15
        case .action:
            self.backgroundColor = .systemBlue
            self.layer.cornerRadius = 15
        case .orangeish:
            self.backgroundColor = .tintColor
            self.layer.cornerRadius = 15
            self.titleLabel?.font = .systemFont(ofSize: 20)
            self.setTitleColor(AppColor().textWhite, for: .normal)
        case .line:
            self.setTitleColor(AppColor().textGray, for: .normal)
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
        self.addTarget(self, action: #selector(myButtonTapped), for: .touchUpInside)
    }
    required init?(coder: NSCoder) {
        nil
    }
    @objc private func myButtonTapped() {
        self.onTap()
    }
}

extension UITextView {
    func setStyle(_ style: TextViewStyle) {
        switch style {
        case .plain:
            self.isEditable = true
            self.isScrollEnabled = true
            self.font = UIFont.systemFont(ofSize: 18.0)
            self.textColor = AppColor().textGray
            self.layer.backgroundColor = AppColor().background?.cgColor
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
        }
    }
}

extension UIButton {
    
    convenience init(image: UIImage, action: @escaping () -> Void) {
        self.init()
        self.setImage(image, for: .normal)
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        self.action = action
    }
    
    private var action: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.action) as? () -> Void
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.action, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    @objc private func buttonTapped() {
        self.action?()
    }
    
    private struct AssociatedKeys {
        static var action = "action"
    }
    
}

extension UITextField {
    func setCustomStyle(_ style: TextFieldStyle) {
        switch style {
        case .phoneField:
            self.layer.borderColor = UIColor.systemGray3.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 15
            self.layer.backgroundColor = AppColor().background?.cgColor
            self.font = UIFont.boldSystemFont(ofSize: 25)
            self.keyboardType = .phonePad
            self.textColor = AppColor().textMain
        case .subGeneral:
            self.layer.borderColor = UIColor.systemGray3.cgColor
            self.layer.borderWidth = 1
            self.layer.cornerRadius = 15
            self.layer.backgroundColor = AppColor().background?.cgColor
            self.font = UIFont.boldSystemFont(ofSize: 18)
            self.keyboardType = .default
            self.textColor = .black
            self.addLeftPadding(10)
        case .notFilled:
            self.layer.borderColor = UIColor.red.cgColor
        case .login:
            self.backgroundColor = AppColor().secondaryBackground
            self.layer.borderWidth = 0.5
            self.layer.borderColor = UIColor.systemGray3.cgColor
            self.font = .systemFont(ofSize: 16)
            self.textColor = .black
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always
        case .plain:
            self.backgroundColor = AppColor().background
            self.font = .systemFont(ofSize: 16)
            self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
            self.leftViewMode = .always
            self.layer.cornerRadius = 10
            self.clipsToBounds = true
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
            self.textColor = AppColor().textMain
            self.textAlignment = .center
        case .subtitle:
            self.font = UIFont.systemFont(ofSize: 20)
            self.textAlignment = .center
            self.textColor = AppColor().textMain
        case .grayBig:
            self.font = UIFont.boldSystemFont(ofSize: 20)
            self.textColor = AppColor().textGray
            self.textAlignment = .center
        case .grayMedium:
            self.font = UIFont.boldSystemFont(ofSize: 15)
            self.textColor = AppColor().textGray
            self.textAlignment = .center
        case .miniTitle:
            self.font = UIFont.systemFont(ofSize: 10)
            self.textColor = AppColor().textGray
            self.textAlignment = .center
        case .feedTitle:
            self.font = UIFont.boldSystemFont(ofSize: 20)
            self.textColor = AppColor().textMain
            self.textAlignment = .left
        case .feedBody:
            self.font = UIFont.systemFont(ofSize: 15)
            self.textColor = AppColor().textMain
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

struct AppColor {
    let background = UIColor(named: "background")
    let textMain = UIColor(named: "textMain")
    let textWhite = UIColor(named: "textWhite")
    let textGray = UIColor(named: "textGray")
    let secondaryBackground = UIColor(named: "secondaryBackground")
}
