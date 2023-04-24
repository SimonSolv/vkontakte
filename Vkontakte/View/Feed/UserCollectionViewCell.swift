//
//  UserCollectionViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 03.03.2023.
//

import UIKit
import SnapKit

class UserCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "UserCollectionViewCell"
    
    var user: UserData? {
        didSet {
            guard let user = user else {
                print("User is nil in UserCollectionViewCell")
                return
            }
            self.userAvatar.image = CoreDataManager.shared.unpackPicture(picture: user.avatar!) ?? UIImage(named: "DefaultAvatar")!
            if user.isLogged == true {
                addGreenCircle()
            }
        }
    }
    
    lazy var userAvatar: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.borderWidth = 2
        return view
    }()
    
    //MARK: - Setup
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        contentView.addGestureRecognizer(tapGestureRecognizer)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        contentView.addSubview(userAvatar)
    }
    
    private func setupConstraints() {
        userAvatar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
    }
    
    private func addGreenCircle() {
        let view = UIImageView()
        view.image = UIImage(systemName: "circle.fill")
        view.tintColor = .green
        view.layer.borderColor = UIColor.orange.cgColor
        view.layer.borderWidth = 1
        view.clipsToBounds = true
        view.layer.cornerRadius = 7
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.top.equalTo(userAvatar.snp.top).offset(45)
            make.centerX.equalTo(userAvatar.snp.centerX).offset(21)
            make.height.equalTo(14)
            make.width.equalTo(14)
        }
    }
    
    @objc private func handleTap() {
        let notificationName = Notification.Name("ShowProfile")
        let notification = Notification(name: notificationName, object: nil, userInfo: ["id": user!.id!])
        NotificationCenter.default.post(notification)
    }
}
