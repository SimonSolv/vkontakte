//
//  PhotoCollectionViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 14.03.2023.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "PhotoCollectionViewCell"
    
    var source: String? {
        didSet {
            if source == "plus" {
                self.picture.image = UIImage(systemName: source!)
                self.picture.tintColor = .orange
                self.picture.layer.borderColor = UIColor.orange.cgColor
                self.picture.layer.borderWidth = 1
                self.picture.contentMode = .center
            } else {
                self.picture.image = UIImage(named: source!)
            }
        }
    }
    
    private lazy var picture: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
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
        contentView.addSubview(picture)
    }
    
    private func setupConstraints() {
        picture.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(70)
        }
    }
}
