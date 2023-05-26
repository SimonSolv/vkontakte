//
//  LandingViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import UIKit
import SnapKit

class LandingViewController: UIViewController, CoordinatedProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    private lazy var landingPicture: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "landingImage")
        view.backgroundColor = .white
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var registerButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Register"~, for: .normal)
        btn.setCustomStyle(style: .main)
        btn.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var hasAccountButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Have an account"~, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(hasAccountTapped), for: .touchUpInside)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        view.addSubview(landingPicture)
        view.addSubview(registerButton)
        view.addSubview(hasAccountButton)
    }
    
    private func setupConstraints() {
        
        landingPicture.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(50)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(400)
        }
        
        registerButton.snp.makeConstraints { make in
            make.top.equalTo(landingPicture.snp.bottom).offset(50)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(50)
        }
        
        hasAccountButton.snp.makeConstraints { make in
            make.top.equalTo(registerButton.snp.bottom).offset(10)
            make.centerX.equalTo(registerButton.snp.centerX)
            make.height.equalTo(50)
        }
    }
    
    @objc private func registerButtonTapped() {
        coordinator?.event(action: .showRegisterPage, iniciator: self)
    }
    
    @objc private func hasAccountTapped() {
        coordinator?.event(action: .hasAccount, iniciator: self)
    }
}
