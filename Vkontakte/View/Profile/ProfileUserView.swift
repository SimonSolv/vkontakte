//
//  ProfileUserView.swift
//  Vkontakte
//
//  Created by Simon Pegg on 06.03.2023.
//

import UIKit
import CoreData
import SnapKit

class ProfileUserView: UIView {
    
    var user: UserData? {
        didSet {
            self.avatar.image = UIImage(named: user?.avatar ?? "DefaultAvatar")
            self.name.text = "\(user!.name ?? "Unknown") \(user!.lastName ?? "")"
            self.job.text = "\(user!.jobTitle ?? "")"
        }
    }
    
    lazy var avatar: UIImageView = {
        let image = UIImageView()
        image.setCustomStyle(style: .avatar)
        return image
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .subtitle)
        label.textAlignment = .left
        return label
    }()
    
    lazy var job: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .grayMedium)
        label.textAlignment = .left
        return label
    }()
    
    lazy var additionalInfoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Additional info", for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 20)
        btn.setTitleColor(.black, for: .normal)
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    lazy var i_image: UIImageView = {
        let imgview = UIImageView()
        let img = UIImage(systemName: "info.circle.fill")
        img?.withTintColor(.orange)
        imgview.image = img
        return imgview
    }()
    
    lazy var editButton: UIButton = {
        let btn = UIButton()
        btn.setCustomStyle(style: .orangeish)
        btn.setTitle("Edit", for: .normal)
        return btn
    }()
    
    lazy var messageButton: UIButton = {
        let btn = UIButton()
        btn.setCustomStyle(style: .main)
        btn.setTitle("Message", for: .normal)
        return btn
    }()
    
    lazy var callButton: UIButton = {
        let btn = UIButton()
        btn.setCustomStyle(style: .main)
        btn.setTitle("Call", for: .normal)
        btn.isEnabled = false
        return btn
    }()

    //MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        let current = getViewType()
        setupView(current: current)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(current: Bool) {
        addSubview(avatar)
        addSubview(name)
        addSubview(job)
        addSubview(i_image)
        addSubview(additionalInfoButton)
        switch current {
        case true:
            addSubview(editButton)
        case false:
            addSubview(messageButton)
            addSubview(callButton)
        }
        setupConstraints(current: current)
    }
    
    //MARK: - Constraints
    
    func setupConstraints(current: Bool) {
        
        avatar.snp.makeConstraints {make in
            make.top.equalTo(snp.top).offset(5)
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.leading.equalTo(snp.leading).offset(15)
        }
        
        name.snp.makeConstraints {make in
            make.top.equalTo(avatar.snp.top).offset(5)
            make.trailing.equalTo(snp.trailing).offset(-15)
            make.leading.equalTo(avatar.snp.trailing).offset(15)
        }
        
        job.snp.makeConstraints {make in
            make.top.equalTo(name.snp.bottom).offset(10)
            make.trailing.equalTo(snp.trailing).offset(-15)
            make.leading.equalTo(avatar.snp.trailing).offset(15)
        }
        
        i_image.snp.makeConstraints {make in
            make.top.equalTo(job.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.leading.equalTo(avatar.snp.trailing).offset(15)
        }
        
        additionalInfoButton.snp.makeConstraints {make in
            make.centerY.equalTo(i_image.snp.centerY)
            make.height.equalTo(60)
            make.trailing.equalTo(snp.trailing).offset(-15)
            make.leading.equalTo(i_image.snp.trailing).offset(2)
        }
        
        switch current {
        case true:
            editButton.snp.makeConstraints {make in
                make.top.equalTo(additionalInfoButton.snp.bottom).offset(10)
                make.height.equalTo(60)
                make.trailing.equalTo(snp.trailing).offset(-15)
                make.leading.equalTo(avatar.snp.trailing).offset(15)
            }
        case false:
            messageButton.snp.makeConstraints {make in
                make.top.equalTo(additionalInfoButton.snp.bottom).offset(10)
                make.leading.equalTo(avatar.snp.trailing).offset(15)
                make.width.equalTo(100)
                make.height.equalTo(50)
            }
            
            callButton.snp.makeConstraints {make in
                make.top.equalTo(additionalInfoButton.snp.bottom).offset(10)
                make.leading.equalTo(messageButton.snp.trailing).offset(15)
                make.width.equalTo(100)
                make.height.equalTo(50)
            }
        }
    }
    
    func getViewType() -> Bool {
        return false
    }
    
}
