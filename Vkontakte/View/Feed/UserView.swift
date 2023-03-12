//
//  UserView.swift
//  Vkontakte
//
//  Created by Simon Pegg on 03.03.2023.
//

import UIKit
import SnapKit
import CoreData

class UserView: UIView {
    
    var userId: String? {
        didSet {
            self.currentUser = CoreDataManager.shared.getUser(id: userId!)
        }
    }

    var currentUser: UserData? {
        didSet {
            self.name.text = currentUser?.name
            self.job.text = currentUser?.jobTitle ?? ""
            self.avatar.image = UIImage(named: currentUser?.avatar ?? "DefaultAvatar")
        }
    }
    
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
    
    lazy var avatar: UIImageView = {
        let image = UIImageView()
        image.setCustomStyle(style: .avatar)
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(name)
        addSubview(job)
        addSubview(avatar)
        
        avatar.snp.makeConstraints {make in
            make.top.equalTo(snp.top).offset(5)
            make.height.equalTo(60)
            make.width.equalTo(60)
            make.leading.equalTo(snp.leading).offset(15)
        }
        
        name.snp.makeConstraints {make in
            make.top.equalTo(avatar.snp.top).offset(2)
            make.height.equalTo(20)
            make.trailing.equalTo(snp.trailing)
            make.leading.equalTo(avatar.snp.trailing).offset(20)
        }
        
        job.snp.makeConstraints {make in
            make.top.equalTo(name.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.trailing.equalTo(name.snp.trailing)
            make.leading.equalTo(name.snp.leading)
        }
    }
    
}

