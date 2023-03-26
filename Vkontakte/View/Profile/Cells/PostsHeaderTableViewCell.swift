//
//  PostsHeaderTableViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 25.03.2023.
//

import UIKit
import SnapKit

class PostsHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "PostsHeaderTableViewCell"
    
    var delegate: PostsHeaderTableViewCellDelegate?
    
    var isLogged: Bool? {
        didSet {
            addCreatePost()
        }
    }
    
    var user: UserData? {
        didSet {
            setup()
            guard let user = user else {
                print("User is nil in PostsHeaderTableViewCell")
                return
            }
            self.isLogged = user.isLogged
            titleLabel.text = "\(user.posts?.count ?? 0) Posts"
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.setCustomStyle(style: .feedTitle)
        view.text = "Posts"
        return view
    }()
    
    private lazy var addPostButton: UIButton = {
        let view = UIButton()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 33))
        imageView.image = UIImage(systemName: "doc.badge.plus")
        imageView.contentMode = .scaleAspectFill
        view.addSubview(imageView)
        view.addTarget(self, action: #selector(addPostButtonTapped), for: .touchUpInside)
        return view
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        contentView.addSubview(titleLabel)
        self.selectionStyle = .none
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(15)
            make.centerX.equalTo(contentView.snp.centerX)
            make.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
    }
    
    private func addCreatePost() {
        if self.isLogged == true {
            contentView.addSubview(addPostButton)
            addPostButton.snp.makeConstraints { make in
                make.centerY.equalTo(contentView.snp.centerY)
                make.trailing.equalTo(contentView.snp.trailing).offset(-20)
                make.height.equalTo(30)
                make.width.equalTo(40)
            }
        }
    }
    
    @objc private func addPostButtonTapped() {
        delegate?.createPost()
    }

}
