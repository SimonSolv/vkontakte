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
    
    var user: User? {
        didSet {
            self.userAvatar.image = UIImage(named: user?.pictures?[0] ?? "DefaultAvatar")
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
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(userAvatar)
    }
    
    private func setupConstraints() {
        userAvatar.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(60)
        }
    }
}
