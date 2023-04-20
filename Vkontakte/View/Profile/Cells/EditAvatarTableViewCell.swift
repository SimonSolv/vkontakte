//
//  EditAvatarTableViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 29.03.2023.
//

import UIKit
import SnapKit

protocol EditAvatarTableViewCellDelegate: AnyObject {
    func editAvatarTapped()
}

class EditAvatarTableViewCell: UITableViewCell {
    
    static let identifier = "EditAvatarTableViewCell"
    
    var delegate: EditAvatarTableViewCellDelegate?
    
    let manager = CoreDataManager.shared
    
    private lazy var avatar: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        let picture = manager.currentUser!.avatar!
        let image = manager.unpackPicture(picture: picture)
        view.image = image
        return view
    }()
    
    private lazy var editAvatarButton: UIButton = {
        let view = UIButton(image: UIImage(systemName: "pencil")!.withRenderingMode(.alwaysTemplate)) { [self] in
            editAvatarTapped()
        }
        view.imageView?.contentMode = .scaleAspectFit
        view.transform = CGAffineTransform(scaleX: 2, y: 2)
        view.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .systemGray4
        contentView.addSubview(avatar)
        contentView.addSubview(editAvatarButton)
        
        avatar.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        editAvatarButton.snp.makeConstraints { make in
            make.bottom.equalTo(avatar.snp.bottom).offset(-40)
            make.trailing.equalTo(avatar.snp.trailing).offset(-40)
            make.height.equalTo(25)
            make.width.equalTo(25)
        }
    }
    
    private func editAvatarTapped() {
        delegate?.editAvatarTapped()
    }
}
