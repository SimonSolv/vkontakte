//
//  LoginViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 10.03.2023.
//

import UIKit

class LoginViewController: UIViewController, CoordinatedProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    private var userLogin: String?
    
    private var userPassword: String?
    
    private var inspector = LoginInspector()
    
    private let biometricIDAuthentification = LocalAuthorizationService()
    
    //MARK: - Views
    
    lazy var signInLineButton: UIButton = {
        let btn = UIButton()
        btn.setCustomStyle(style: .line)
        return btn
    }()
    
    lazy var useAuthButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Press to use biometry"~, for: .normal)
        btn.setTitleColor(UIColor.systemBlue, for: .normal)
        btn.addTarget(self, action: #selector(authButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var logoImageView: UIView = {
        let image: UIImageView = UIImageView()
        image.image = UIImage(named: "landingImage")
        image.sizeToFit()
        return image
    }()
    
    lazy var loginButton: UIButton = {
        var btn = UIButton()
        btn.setCustomStyle(style: .orangeish)
        btn.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        btn.setTitle("Log in", for: .normal)
        return btn
    }()
    
    lazy var loginTextField: UITextField = {
        var textfield: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        textfield.setCustomStyle(.login)
        textfield.placeholder = "Email or phone"
        textfield.addTarget(self, action: #selector(loginTextChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(passwordFieldTapped), for: .editingDidBegin)
        textfield.keyboardType = .emailAddress
        return textfield
    }()
    
    lazy var passwordTextField: UITextField = {
        var textfield: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
        textfield.setCustomStyle(.login)
        textfield.placeholder = "Password"
        textfield.addTarget(self, action: #selector(passwordTextChanged), for: .editingChanged)
        textfield.addTarget(self, action: #selector(passwordFieldTapped), for: .editingDidBegin)
        textfield.addTarget(self, action: #selector(secureTypeOn), for: .editingDidBegin)
        return textfield
    }()
    
    lazy var wrongPswdView: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.text = "Incorrect login or password"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    lazy var inputSourceView: UIStackView = {
        var view = UIStackView()
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.axis = .vertical
        return view
    }()
    
    lazy var contentView = UIScrollView()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        navigationItem.hidesBackButton = true
        setupViews()
        setupConstraits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        biometricIDAuthentification.canEvaluate {result, type, error in
            guard result else {
                return
            }
            self.setupAuthButton(type: type)
        }

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    //MARK: Setup
        func setupViews() {
            view.backgroundColor = .white
            view.addSubview(contentView)
            contentView.addSubview(logoImageView)
            contentView.addSubview(loginButton)
            contentView.addSubview(inputSourceView)
            inputSourceView.addSubview(loginTextField)
            inputSourceView.addSubview(passwordTextField)
            contentView.addSubview(signInLineButton)
            contentView.addSubview(useAuthButton)
        }
        
    func setupConstraits() {
        
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        logoImageView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top).offset(view.bounds.height/7)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        inputSourceView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImageView.snp.bottom).offset(view.bounds.height/7)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.width.equalTo(view.bounds.width - 40)
            make.height.equalTo(100)
        }
        
        loginTextField.snp.makeConstraints { (make) in
            make.top.equalTo(inputSourceView.snp.top)
            make.leading.equalTo(inputSourceView.snp.leading)
            make.trailing.equalTo(inputSourceView.snp.trailing)
            make.height.equalTo(50)
        }
        
        passwordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(inputSourceView.snp.top).offset(50)
            make.leading.equalTo(inputSourceView.snp.leading)
            make.trailing.equalTo(inputSourceView.snp.trailing)
            make.height.equalTo(50)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.top.equalTo(passwordTextField.snp.bottom).offset(20)
            make.height.equalTo(50)
            make.leading.equalTo(inputSourceView.snp.leading)
            make.trailing.equalTo(inputSourceView.snp.trailing)
        }
        
        signInLineButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
            make.top.equalTo(loginButton.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        useAuthButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(400)
            make.top.equalTo(signInLineButton.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
        }
    }
    
    func unvealdPassword(password: String) {
        self.passwordTextField.isSecureTextEntry = false
        self.passwordTextField.text = password
    }
    
    @objc func loginTextChanged(_ textField: UITextField) {
      //  userName = textField.text
        wrongPswdView.isHidden = true
        inputSourceView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    @objc func passwordTextChanged(_ textField: UITextField) {
        userPassword = textField.text
        wrongPswdView.isHidden = true
        inputSourceView.layer.borderColor = UIColor.lightGray.cgColor
    }

    @objc func secureTypeOn(_ textField: UITextField) {
        textField.isSecureTextEntry = true
    }

    @objc func passwordFieldTapped(_ textField: UITextField) {
        wrongPswdView.isHidden = true
        inputSourceView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func signInButtonTapped() {
        let controller = LandingViewController()
      //  controller.delegate = self.inspector
        self.present(controller, animated: true)
    }
    
    @objc func loginButtonTapped() {
        if self.loginTextField.text != "" && self.passwordTextField.text != "" {
//            inspector.checkCredentials(email: self.loginTextField.text!, password: self.passwordTextField.text!, iniciator: self, realm: true)
        } else {
//            self.present(loginAlert(), animated: true, completion: nil)
            return
        }
    }
    
    @objc func authButtonTapped() {

        biometricIDAuthentification.canEvaluate { (canEvaluate, type, canEvaluateError) in
            guard canEvaluate else {
                let alertController = UIAlertController (title: "Setup your biometry"~, message: "Go to Settings?"~, preferredStyle: .alert)

                let settingsAction = UIAlertAction(title: "Settings"~, style: .default) { (_) -> Void in

                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }

                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)") // Prints true
                        })
                    }
                }
                alertController.addAction(settingsAction)
                let cancelAction = UIAlertAction(title: "Cancel"~, style: .default, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                return
            }
            
            DispatchQueue.main.async {
                self.setupAuthButton(type: type)
            }
            
            biometricIDAuthentification.evaluate { [weak self] (success, error) in
                guard success else {
                    self?.alert(
                        title: "Error"~,
                        message: error?.localizedDescription ?? "Face ID/Touch ID may not be configured"~,
                        okActionTitle: "Confirm"~)
                    return
                }
                let user = CoreDataManager.shared.getUserByName(name: "Leonardo")!
                self!.coordinator?.event(action: .loginSuccess(user: user), iniciator: self!)
                CoreDataManager.shared.setUserOnline(user: user)
                CoreDataManager.shared.getCurrentUser()
            }
        }
    }
    
    func alert(
        title: String,
        message: String,
        okActionTitle: String
    ) {
        let alertView = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: okActionTitle,
            style: .default
        )
        alertView.addAction(okAction)
        present(
            alertView,
            animated: true
        )
    }
    
    func setupAuthButton(type: BiometricType) {
        switch type {
        case .faceID:
            DispatchQueue.main.async {
                self.useAuthButton.setTitle(" Use FaceID", for: .normal)
                self.useAuthButton.setImage(UIImage(systemName: "faceid"), for: .normal)
            }
        case.touchID:
            DispatchQueue.main.async {
                self.useAuthButton.setTitle(" Use TouchID", for: .normal)
                self.useAuthButton.setImage(UIImage(systemName: "touchid"), for: .normal)
            }

        case .none:
            DispatchQueue.main.async {
                self.useAuthButton.setTitle("", for: .normal)
            }
        case .unknown:
            DispatchQueue.main.async {
                self.useAuthButton.setTitle("Setup your biometry", for: .normal)
            }
        }
    }


}

private extension LoginViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            contentView.contentInset.bottom = keyboardSize.height
            contentView.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height - 80,
                right: 0
            )
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        contentView.contentInset.bottom = .zero
        contentView.verticalScrollIndicatorInsets = .zero
    }
}

 



