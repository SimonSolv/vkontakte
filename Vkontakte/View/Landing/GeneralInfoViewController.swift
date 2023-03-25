//
//  GeneralInfoViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import UIKit
import SnapKit

class GeneralInfoViewController: UIViewController, CoordinatedProtocol {
    
    enum FieldCheckerAlert {
        case wrongName
        case wrongNickName
        case notAllFilled
        case allGood
    }
    
    //MARK: - Properties
    
    var coordinator: CoordinatorProtocol?
    
    weak var bottomConstraint: NSLayoutConstraint!
    
    private var scroll = UIScrollView()
    
    var dateOfBirth: Date?
    
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        return picker
    }()
    
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
    
    private lazy var dateOfBirthLabel: UILabel = {
        let label = UILabel()
        label.text = "Date of Birth*"
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
        scroll.addSubview(dateOfBirthLabel)
        scroll.addSubview(datePicker)
        scroll.addSubview(confirmButton)
        nameTextField.delegate = self
        lastNameTextField.delegate = self
        jobTextField.delegate = self
        nickNameTextField.delegate = self
        let calendar = Calendar.current
        let currentDate = Date()
        let maxDateComponents = DateComponents(year: -18)
        let minDateComponents = DateComponents(year: -100)
        let maxDate = calendar.date(byAdding: maxDateComponents, to: currentDate)
        let minDate = calendar.date(byAdding: minDateComponents, to: currentDate)
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        datePicker.maximumDate = maxDate
        datePicker.minimumDate = minDate
        datePicker.date = maxDate ?? currentDate
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
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.leading.equalTo(scroll.snp.leading).offset(20)
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
        }
        
        jobTextField.snp.makeConstraints { make in
            make.top.equalTo(jobLabel.snp.bottom).offset(5)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        dateOfBirthLabel.snp.makeConstraints { make in
            make.top.equalTo(jobTextField.snp.bottom).offset(20)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.width.equalTo(scroll.snp.width).offset(-40)
            make.height.equalTo(40)
        }
        
        datePicker.snp.makeConstraints { make in
            make.top.equalTo(dateOfBirthLabel.snp.bottom).offset(2)
            make.leading.equalTo(scroll.snp.leading).offset(20)
            make.trailing.equalTo(scroll.snp.trailing).offset(-20)
        }
        
        annotationLabel.snp.makeConstraints { make in
            make.top.equalTo(datePicker.snp.bottom).offset(20)
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
        let isAllFilled = checkNeccessaryFields()
        switch isAllFilled {
        case .wrongNickName:
            CustomAlert.showAlert(title: "Warning!", message: "Sorry, this Nickname is taken by other user", okActionTitle: "Ok", viewController: self)
        case .notAllFilled:
            CustomAlert.showAlert(title: "Warning!", message: "Please, fill all neccessary fields", okActionTitle: "Ok", viewController: self)
        case .wrongName:
            CustomAlert.showAlert(title: "Warning!", message: "Please, fill all neccessary fields", okActionTitle: "Ok", viewController: self)
        case .allGood:
            let coreManager = CoreDataManager.shared
            coreManager.createUser(name: nameTextField.text!, lastName: lastNameTextField.text ?? "", jobTitle: jobTextField.text ?? "", nickName: nickNameTextField.text!, dateOfBirth: datePicker.date, avatar: "", isLogged: true)
            let current = coreManager.getUserByNick(nickName: nickNameTextField.text!)
            coreManager.fetchUsers()
            CustomAlert.showAlert(title: "Success!", message: "You have now account in our app", okActionTitle: "Ok",okActionHandler: {
                self.coordinator?.ivent(action: .loginSuccess(id: (current?.id)!), iniciator: self)
            }, viewController: self)
        }
    }
    
    private func checkNeccessaryFields() -> FieldCheckerAlert {
        var state: FieldCheckerAlert = .allGood
        var first = true
        var second = true
        var third = true
        if nameTextField.text == "" {
            nameTextField.setCustomStyle(.notFilled)
            first = false
        } else {
            nameTextField.setCustomStyle(.subGeneral)
        }
        if nickNameTextField.text == "" {
            nickNameTextField.setCustomStyle(.notFilled)
            second = false
        } else if nickNameTextField.text != "" {
            let coreManager = CoreDataManager.shared
            let users = coreManager.users
            for user in users {
                if user.nickName == nickNameTextField.text {
                    third = false
                }
            }
        } else {
            nickNameTextField.setCustomStyle( .subGeneral)
        }
        if first == false {
            state = .notAllFilled
        } else if second == false {
            state = .notAllFilled
        } else if third == false {
            state = .wrongNickName
        }
        return state
    }
    
    @objc func datePickerValueChanged() {
        self.dateOfBirth = datePicker.date
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

