//
//  UserView.swift
//  Vkontakte
//
//  Created by Simon Pegg on 03.03.2023.
//

import UIKit
import SnapKit

class UserView: UIView {
    
    var userId: String? {
        didSet {
            backgroundColor = .clear
            guard let id = userId else {
                print("Id, provided in UserView is nil")
                return
            }
            let currentUser = CoreDataManager.shared.getUser(id: id)
            guard let currentUser = currentUser else {
                print("Couldnt get user via id provided in UserView")
                return
            }
            self.name.text = currentUser.name
            self.job.text = currentUser.jobTitle ?? ""
            self.avatar.image = UIImage(data: (currentUser.avatar?.img)!) ?? UIImage(named: "DefaultAvatar")
            setupView()
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
    
    private func setupView() {
        addSubview(avatar)
        addSubview(name)
        addSubview(job)
        
        avatar.snp.makeConstraints {make in
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        name.snp.makeConstraints {make in
            make.top.equalTo(avatar.snp.top).offset(9)
            make.height.equalTo(20)
            make.leading.equalTo(avatar.snp.trailing).offset(20)
        }
        
        job.snp.makeConstraints {make in
            make.top.equalTo(name.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.leading.equalTo(name.snp.leading)
        }
    } 
}

