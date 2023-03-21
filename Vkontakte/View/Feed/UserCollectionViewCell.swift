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
            self.userAvatar.image = UIImage(named: user?.avatar ?? "DefaultAvatar")
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
    
    @objc private func handleTap() {
        let notificationName = Notification.Name("ShowProfile")
        // Create the notification
        let notification = Notification(name: notificationName, object: nil, userInfo: ["id": user!.id!])
        // Post the notification to the notification center
        NotificationCenter.default.post(notification)

    }
}
