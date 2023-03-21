//
//  ConfirmationViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import UIKit
import SnapKit

class ConfirmationViewController: UIViewController, CoordinatedProtocol {

    var coordinator: CoordinatorProtocol?
    
    var delegate = RegisterViewModel()
    
    var phoneNumber: String? {
        didSet {
            phoneNumberLabel.text = phoneNumber
        }
    }
    
    private lazy var checkMark: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "CheckMark")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 25)
        label.text = "Registration confirmation"
        label.textColor = .orange
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Sending SMS on your phone"
        label.textColor = .systemGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = ""
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private lazy var enterCodeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "Please, enter code from SMS"
        label.textColor = .systemGray2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var codeEnteringTextView: UITextField = {
        let textField = UITextField()
        textField.textAlignment = .center
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        textField.setCustomStyle(.phoneField)
        return textField
    }()
    
    private lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Confirm", for: .normal)
        btn.setCustomStyle(style: .main)
        btn.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.sendNotification(notification:)),
                                               name: Notification.Name("AccessReceived"),
                                               object: nil)
    }
    
    private func setupViews() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel)
        view.addSubview(phoneNumberLabel)
        view.addSubview(enterCodeLabel)
        view.addSubview(codeEnteringTextView)
        view.addSubview(confirmButton)
        view.addSubview(checkMark)
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(100)
            make.height.equalTo(30)
            make.centerX.equalTo(view.snp.centerX)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(20)
        }
        
        phoneNumberLabel.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(40)
            make.leading.equalTo(view.snp.leading).offset(10)
            make.trailing.equalTo(view.snp.trailing).offset(-40)
            make.height.equalTo(30)
        }
        
        enterCodeLabel.snp.makeConstraints { make in
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(30)
        }
        
        codeEnteringTextView.snp.makeConstraints { make in
            make.top.equalTo(enterCodeLabel.snp.bottom).offset(5)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(200)
            make.height.equalTo(60)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.top.equalTo(codeEnteringTextView.snp.bottom).offset(20)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(view.snp.width).offset(-100)
            make.height.equalTo(50)
        }
        
        checkMark.snp.makeConstraints { make in
            make.top.equalTo(view.snp.bottom).offset(-220)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
    }
    
    @objc private func confirmButtonTapped() {
        if self.delegate.checkConfirmationCode(code: self.codeEnteringTextView.text) == true {
            self.coordinator?.ivent(action: .addGeneralInfo, iniciator: self)
        } else {
            //resolve problem
            print ("Code is not valid")
        }
    }
    
    @objc private func sendNotification(notification: NSNotification) {
        coordinator?.ivent(action: .sendNotification, iniciator: self)
    }
    
    @objc private func textFieldChanged() {
        if codeEnteringTextView.text?.count == 4 {
            self.confirmButton.makeEnable()
        } else {
            self.confirmButton.makeDisable()
        }
    }

}
