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
    
    var delegate: ProfileUserViewDelegate? {
        didSet {
            userView.delegate = delegate
        }
    }
    
    private lazy var userView: ProfileUserView = {
        let view = ProfileUserView()
        view.isUserInteractionEnabled = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        self.selectionStyle = .none
    }
    
    private func setupView() {
        contentView.addSubview(userView)
        userView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
