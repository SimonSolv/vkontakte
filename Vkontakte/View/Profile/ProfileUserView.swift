//
//  ProfileUserView.swift
//  Vkontakte
//
//  Created by Simon Pegg on 06.03.2023.
//

import UIKit
import CoreData
import SnapKit

protocol ProfileUserViewDelegate: AnyObject {
    func additionalInfoTapped(user: UserData)
    func messageButtonTapped(user: UserData)
    func editButtonTapped(user: UserData)
    func postsTapped(user: UserData)
    func subscribersTapped(user: UserData)
    func subscriptionsTapped(user: UserData)
}

class ProfileUserView: UIView {
    
    var isCurrentUser: Bool?
    
    let coreManager = CoreDataManager.shared
    
    var user: UserData? {
        didSet {
            guard let user = user else { return }
            self.isCurrentUser = user.isLogged
            setupView()
            avatar.image = coreManager.unpackPicture(picture: user.avatar!) ?? UIImage(named: "DefaultAvatar")!
            name.text = "\(user.name ?? "Unknown User") \(user.lastName ?? "")"
            job.text = "\(user.jobTitle ?? "  ")"
            publicationsLabel.text = "\(user.posts?.count ?? 0)" + "\nposts"~
            subscriptionsLabel.text = "\(user.subscriptions?.count ?? 0)" + "\nsubscriptions"~
            subscribersLabel.text = "\(user.subscribers?.count ?? 0)" + "\nsubscribers"~
        }
    }
    
    weak var delegate: ProfileUserViewDelegate?
    
    private lazy var avatar: UIImageView = {
        let image = UIImageView()
        image.setCustomStyle(style: .avatar)
        return image
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .subtitle)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var job: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .grayMedium)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var additionalInfoButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Additional info"~, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        btn.setTitleColor(AppColor().textMain, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(additionalTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var i_image: UIImageView = {
        let imgview = UIImageView()
        let img = UIImage(systemName: "info.circle.fill")
        imgview.tintColor = .orange
        imgview.image = img
        return imgview
    }()
    
    private lazy var editButton: UIButton = {
        let btn = UIButton()
        btn.setCustomStyle(style: .orangeish)
        btn.setTitle("Edit"~, for: .normal)
        btn.addTarget(self, action: #selector(editTapped), for: .touchUpInside)
        return btn
    }()
    
    private lazy var messageButton: UIButton = {
        let view = UIButton()
        view.setCustomStyle(style: .main)
        view.setTitle("Message"~, for: .normal)
        view.addTarget(self, action: #selector(messageTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var callButton: UIButton = {
        let btn = UIButton()
        btn.setCustomStyle(style: .main)
        btn.setTitle("Call"~, for: .normal)
        btn.isEnabled = false
        return btn
    }()
    
    private var hStack: UIStackView = UIStackView()

    private lazy var publicationsLabel: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subscribersLabel: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    private lazy var subscriptionsLabel: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    //MARK: - Setup
    
    init() {
        super.init(frame: .zero)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(avatar)
        addSubview(name)
        addSubview(job)
        addSubview(i_image)
        addSubview(additionalInfoButton)
        additionalInfoButton.isUserInteractionEnabled = true
        if isCurrentUser == true {
            addSubview(editButton)
            editButton.isUserInteractionEnabled = true
        }
            else {
            addSubview(messageButton)
            addSubview(callButton)
        }
        hStack = UIStackView(arrangedSubviews: [ publicationsLabel,subscribersLabel, subscriptionsLabel])
        hStack.axis = .horizontal
        addSubview(hStack)
        setupConstraints()
    }
    
    //MARK: - Constraints
    
    private func setupConstraints() {
        
        avatar.snp.makeConstraints {make in
            make.top.equalTo(snp.top).offset(20)
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.leading.equalTo(snp.leading).offset(20)
        }
        
        name.snp.makeConstraints {make in
            make.top.equalTo(avatar.snp.top).offset(-5)
            make.trailing.equalTo(snp.trailing).offset(-15)
            make.leading.equalTo(avatar.snp.trailing).offset(20)
        }
        
        job.snp.makeConstraints {make in
            make.top.equalTo(name.snp.bottom).offset(5)
            make.trailing.equalTo(snp.trailing).offset(-15)
            make.leading.equalTo(avatar.snp.trailing).offset(20)
        }
        
        i_image.snp.makeConstraints {make in
            make.top.equalTo(job.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.width.equalTo(20)
            make.leading.equalTo(avatar.snp.trailing).offset(20)
        }
        
        additionalInfoButton.snp.makeConstraints {make in
            make.centerY.equalTo(i_image.snp.centerY)
            make.trailing.equalTo(snp.trailing).offset(-15)
            make.leading.equalTo(i_image.snp.trailing).offset(4)
        }
        
        if isCurrentUser == true {
            
            editButton.snp.makeConstraints {make in
                make.top.equalTo(avatar.snp.bottom).offset(10)
                make.height.equalTo(50)
                make.leading.equalTo(snp.leading).offset(20)
                make.trailing.equalTo(snp.trailing).offset(-20)
            }
            
            hStack.snp.makeConstraints { make in
                make.top.equalTo(editButton.snp.bottom).offset(15)
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.bottom.equalTo(snp.bottom).offset(-15)
            }
            
        } else {
            
            messageButton.snp.makeConstraints {make in
                make.top.equalTo(additionalInfoButton.snp.bottom).offset(10)
                make.leading.equalTo(snp.leading).offset(20)
                make.trailing.equalTo(callButton.snp.leading).offset(-20)
                make.height.equalTo(50)
            }
            
            callButton.snp.makeConstraints {make in
                make.top.equalTo(messageButton.snp.top)
                make.trailing.equalTo(snp.trailing).offset(-20)
                make.height.equalTo(50)
                make.width.equalTo(messageButton.snp.width)
            }
            
            hStack.snp.makeConstraints { make in
                make.top.equalTo(callButton.snp.bottom).offset(15)
                make.left.equalTo(snp.left)
                make.right.equalTo(snp.right)
                make.bottom.equalTo(snp.bottom).offset(-15)
            }
        }
    }
    
    //MARK: - Actions
    
    @objc private func additionalTapped() {
        guard let user = user else {
            return
        }
        delegate?.additionalInfoTapped(user: user)
    }
    
    @objc private func editTapped() {
        guard let user = user else {
            return
        }
        delegate?.editButtonTapped(user: user)
    }
    
    @objc private func messageTapped() {
        guard let user = user else {
            return
        }
        delegate?.messageButtonTapped(user: user)
    }
}
