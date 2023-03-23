//
//  ProfileUserTableViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 12.03.2023.
//

import UIKit
import SnapKit

class ProfileUserTableViewCell: UITableViewCell {
    
    static let identifier = "ProfileUserTableViewCell"
    
    var id: String? {
        didSet {
            userView.userId = id
        }
    }
    
    var delegate: ProfileUserViewDelegate?
    
    private lazy var userView: ProfileUserView = {
        let view = ProfileUserView()
        view.delegate = self.delegate
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        self.selectionStyle = .none
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
