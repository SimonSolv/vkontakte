//
//  ProfileUserTableViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 12.03.2023.
//

import UIKit
import SnapKit

class ProfileUserTableViewCell: UITableViewCell, UserContainsProtocol {
    
    static let identifier = "ProfileUserTableViewCell"
    
    var userId: String
    
    private lazy var userView: ProfileUserView = {
        let view = ProfileUserView(dataSource: self)
        return view
    }()

    init(userId: String, reuseIdentifier: String?) {
        self.userId = userId
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(userView)
        userView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
