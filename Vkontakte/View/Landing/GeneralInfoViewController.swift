//
//  GeneralInfoViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import UIKit
import SnapKit

class GeneralInfoViewController: UIViewController, CoordinatedProtocol {
    
    //MARK: - Properties
    
    var coordinator: CoordinatorProtocol?
    
    var user: User?
    
    weak var bottomConstraint: NSLayoutConstraint!
    
    private var scroll = UIScrollView()
    
    private lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Confirm", for: .normal)
        btn.setCustomStyle(style: .main)
        btn.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Please, tell about yourself"
        label.setCustomStyle(style: .title)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var annotationLabel: UILabel = {
        let label = UILabel()
        label.text = "* Fields are neccessary to fill"
        label.setCustomStyle(style: .grayMedium)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var nickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nickname*"
        label.setCustomStyle(style: .subtitle)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var lastNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Last name"
        label.setCustomStyle(style: .subtitle)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var jobLabel: UILabel = {
        let label = UILabel()
        label.text = "Job title"
        label.setCustomStyle(style: .subtitle)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name*"
        label.setCustomStyle(style: .subtitle)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.setCustomStyle(.subGeneral)
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var lastNameTextField: UITextField = {
        let textField = UITextField()
        textField.setCustomStyle(.subGeneral)
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var nickNameTextField: UITextField = {
        let textField = UITextField()
        textField.setCustomStyle(.subGeneral)
        textField.returnKeyType = .next
        return textField
    }()
    
    private lazy var jobTextField: UITextField = {
        let textField = UITextField()
        textField.setCustomStyle(.subGeneral)
        textField.returnKeyType = .done
        return textField
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Add keyboard observer for when keyboard shows up or hides
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        setupViews()
        setupConstraints()
    }

    //MARK: - Setup
    
    private func setupViews() {
        view.addSubview(scroll)
        scroll.addSubview(descriptionLabel)
        scroll.addSubview(nameLabel)
        scroll.addSubview(nameTextField)
        scroll.addSubview(lastNameLabel)
        scroll.addSubview(lastNameTextField)
        scroll.addSubview(jobLabel)
        scroll.addSubview(jobTextField)
        scroll.addSubview(nickNameLabel)
        scroll.addSubview(nickNameTextField)
        scroll.addSubview(annotationLabel)
        scroll.addSubview(confirmButton)
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        jobTextField.delegate = self
        nickNameTextField.delegate = self
    }
    
    private func setupConstraints() {
        
        scroll.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(scroll.snp.top).offset(20)
            make.centerX.equalTo(scroll.snp.centerX)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        lastNameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(20)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(20)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        nickNameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        jobLabel.snp.makeConstraints { make in
            make.top.equalTo(nickNameTextField.snp.bottom).offset(20)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        jobTextField.snp.makeConstraints { make in
            make.top.equalTo(jobLabel.snp.bottom).offset(5)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        annotationLabel.snp.makeConstraints { make in
            make.top.equalTo(jobTextField.snp.bottom).offset(20)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(annotationLabel.snp.bottom).offset(20)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
            make.bottom.equalTo(scroll.snp.bottom).offset(-30)
        }

    }
    
    //MARK: - Methods
    
    @objc private func confirmButtonTapped() {
        if let appDelegate = UIApplication.shared.delegate,
        
            let sceneDelegate = appDelegate as? SceneDelegate {
            // Access the SceneDelegate and call showMainScene()
            sceneDelegate.showMainScene()
        } else {
            print("\(type(of: UIApplication.shared.delegate))")
            // Handle the case where the delegate is not of type SceneDelegate
            print("Error: The app delegate is not of type SceneDelegate")
        }
    }
    
    deinit {
        // Remove the observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }

}


//MARK: - Keyboard appears and disappears

extension GeneralInfoViewController {
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scroll.contentInset.bottom = keyboardSize.height
            scroll.verticalScrollIndicatorInsets = UIEdgeInsets(
                top: 0,
                left: 0,
                bottom: keyboardSize.height - 80,
                right: 0
            )
        }
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        scroll.contentInset.bottom = .zero
        scroll.verticalScrollIndicatorInsets = .zero
    }
}

//MARK: - Textfields go smoothly

extension GeneralInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Move the cursor to the next text field or dismiss the keyboard
        switch textField {
        case nameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            nickNameTextField.becomeFirstResponder()
        case nickNameTextField:
            jobTextField.becomeFirstResponder()
        case jobTextField:
            jobTextField.resignFirstResponder()
        default:
            break
        }

        return true
    }
}

