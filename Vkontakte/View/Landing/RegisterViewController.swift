//
//  RegisterViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import UIKit

class RegisterViewController: UIViewController, CoordinatedProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    var phoneNumber = ""
    
    let closure: (() -> Void)? = {
        
    }
    
    var localNotification: LocalNotificationManager?
    
    var scroll = UIScrollView()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .title)
        label.text = "Registration"
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .grayBig)
        label.text = "Phone number"
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .subtitle)
        label.numberOfLines = 0
        label.text = "To use your phone number for entering the app"
        return label
    }()
    
    private lazy var phoneEnteringTextView: UITextField = {
        let textField = UITextField()
        textField.placeholder = "    +7 987 654 32 10"
        textField.setCustomStyle(.phoneField)
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldChanged), for: .valueChanged)
        textField.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        return textField
    }()
    
    private lazy var nextButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Next", for: .normal)
        btn.setCustomStyle(style: .main)
        btn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    private lazy var annotationTextView: UITextView = {
        let label = UITextView()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Pressing Next you are agree with our Agreement Licence and Privacy Policy"
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        setupViews()
        setupConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setupViews() {
        view.addSubview(scroll)
        scroll.addSubview(titleLabel)
        scroll.addSubview(subTitleLabel)
        scroll.addSubview(descriptionLabel)
        scroll.addSubview(phoneEnteringTextView)
        scroll.addSubview(nextButton)
        scroll.addSubview(annotationTextView)
    }
    
    private func setupConstraints() {
        
        scroll.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(scroll.snp.top).offset(50)
            make.height.equalTo(30)
            make.centerX.equalTo(scroll.snp.centerX)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(60)
            make.centerX.equalTo(scroll.snp.centerX)
            make.height.equalTo(30)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(3)
            make.centerX.equalTo(scroll.snp.centerX)
            make.width.equalTo(300)
            make.height.equalTo(60)
        }
        
        phoneEnteringTextView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(100)
            make.centerX.equalTo(scroll.snp.centerX)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(50)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalTo(phoneEnteringTextView.snp.bottom).offset(70)
            make.width.equalTo(200)
            make.centerX.equalTo(scroll.snp.centerX)
            make.width.equalTo(scroll.snp.width).offset(-100)
            make.height.equalTo(50)
        }
        
        annotationTextView.snp.makeConstraints { make in
            make.top.equalTo(nextButton.snp.bottom).offset(10)
            make.centerX.equalTo(scroll.snp.centerX)
            make.width.equalTo(scroll.snp.width).offset(-100)
            make.height.equalTo(80)
            make.bottom.equalTo(scroll.snp.bottom)
        }
    }
    
    @objc private func nextButtonTapped() {
        coordinator?.ivent(action: .requestNotifications, iniciator: self)
        let service = LocalNotificationManager()
        service.registerNotificationTimeInterval(title: "Verification code", body: "Your code: 0000", interval: 2)

        coordinator?.ivent(action: .showRegistrationConfirmation, iniciator: self)
    }
    
    deinit {
        // Remove the observer when the view controller is deallocated
        NotificationCenter.default.removeObserver(self)
    }
}

extension RegisterViewController: UITextFieldDelegate {


        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            // Check if the user pressed the delete key
            if string.isEmpty {
                // Remove the last character from the phone number string
                if phoneNumber.count > 0 {
                    phoneNumber = String(phoneNumber.dropLast())
                }
            } else {
                // Add the new character to the phone number string
                phoneNumber += string
            }
            // Format the phone number string
            let formattedNumber = formatPhoneNumber(phoneNumber)
            textField.text = formattedNumber
            
            return false
        }
        
        func formatPhoneNumber(_ phoneNumber: String) -> String {
            var formattedNumber = phoneNumber
            // Remove all non-numeric characters
            formattedNumber = formattedNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            
            // Check if the number is too long to format
            guard formattedNumber.count <= 10 else { return "   +7 \(formattedNumber.prefix(10))" }
            
            // Format the number with spaces
            var index = formattedNumber.startIndex
            var formattedString = "    +7 "
            for i in 0..<formattedNumber.count {
                if i == 3 || i == 6 || i == 8 {
                    formattedString += " "
                }
                formattedString.append(formattedNumber[index])
                index = formattedNumber.index(after: index)
                if i == 9 {
                    self.nextButton.makeEnable()
                }
                if i != 9 {
                    self.nextButton.makeDisable()
                }
            }
            return formattedString
        }
    
    @objc private func textFieldChanged() {
        if phoneEnteringTextView.text?.count == 10 {
            self.nextButton.makeEnable()
        } else {
            self.nextButton.makeDisable()
        }
    }
    @objc private func textFieldTapped() {
        NotificationCenter.default.post(name: UIResponder.keyboardWillShowNotification, object: nil)
        self.phoneEnteringTextView.text = "    +7 "
    }
    
}

extension RegisterViewController {

    @objc func keyboardWillShow(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }

        // Adjust the content inset and scroll indicator inset of the scroll view
        scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        scroll.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)

        // Scroll the text field into view
        let rect = scroll.convert(nextButton.frame, from: nextButton.superview)
        scroll.scrollRectToVisible(rect, animated: true)
    }

    @objc func keyboardWillHide(notification: Notification) {
        // Reset the content inset and scroll indicator inset of the scroll view
        scroll.contentInset = .zero
        scroll.scrollIndicatorInsets = .zero
    }
}

