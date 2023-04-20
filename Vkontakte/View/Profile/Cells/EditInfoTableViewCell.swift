//
//  EditInfoTableViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 29.03.2023.
//

import UIKit
import SnapKit

class EditInfoTableViewCell: UITableViewCell {
    
    static let identifier = "EditInfoTableViewCell"

    let titleLabel = UILabel()

    let textField = UITextField()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Set up title label
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.textColor = .darkText
        contentView.addSubview(titleLabel)
        
        // Set up text field
        textField.borderStyle = .roundedRect
        contentView.addSubview(textField)
        
        // Set up constraints for title label and text field
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(10)
        }
        
        textField.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
