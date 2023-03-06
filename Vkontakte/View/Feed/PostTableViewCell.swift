//
//  PostTableViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 03.03.2023.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var delegate: PostTableViewCellDelegate?
    
    static let identifier = "PostTableViewCell"
    
    var source: Post? {
        didSet {
            self.title.text = source?.title
            self.body.text = source?.body
            self.image.image = UIImage(named: source?.image ?? "DefaultPostImage")
            self.userView.user = source?.author
            setupLabel(label: self.likes, image: "heart", text: "\(source?.likes ?? 0)")
            setupLabel(label: self.comments, image: "bubble.middle.bottom", text: "\(source?.comments ?? 0)")
        }
    }
    
    lazy var userView: UserView = {
        let view = UserView()
        return view
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedTitle)
        label.numberOfLines = 2
        return label
    }()
    
    lazy var body: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        label.numberOfLines = 4
        return label
    }()
    
    lazy var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    lazy var likes: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        return label
    }()
    
    lazy var comments: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: - Setup
    private func setupViews() {
        contentView.addSubview(userView)
        contentView.addSubview(title)
        contentView.addSubview(body)
        contentView.addSubview(image)
        contentView.addSubview(likes)
        contentView.addSubview(comments)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likesTapped))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(commentsTapped))
        likes.addGestureRecognizer(tapGesture)
        comments.addGestureRecognizer(tapGesture2)
    }
    
    private func setupConstraints() {
        
        userView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
       //     make.height.equalTo(60)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(70)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.height.equalTo(self.bounds.width/4*3)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).offset(-40)
        }
        
        body.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.height.equalTo(90)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
        
        likes.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.top.equalTo(body.snp.bottom).offset(5)
            make.height.equalTo(15)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.width.equalTo(60)
        }
        
        comments.snp.makeConstraints { make in
            make.top.equalTo(likes.snp.top)
            make.height.equalTo(15)
            make.leading.equalTo(contentView.snp.leading).offset(85)
            make.width.equalTo(60)
        }
    }
    
    private func setupLabel(label: UILabel, image: String, text: String) {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: image)
        imageAttachment.bounds = CGRect(x: 0, y: 0, width: 15, height: 12)
        let attributedString = NSMutableAttributedString(attributedString: NSAttributedString(attachment: imageAttachment))
        attributedString.append(NSAttributedString(string: " " + text))
        label.attributedText = attributedString
    }
                                                
    @objc private func likesTapped() {
        updateLikes(state: true)
    }
    
    @objc private func commentsTapped() {
        self.delegate?.openPost(comment: true)
    }
    
    private func updateLikes(state: Bool) {
        self.delegate?.liked(status: state)
    }
}

protocol PostTableViewCellDelegate {
    func openPost(comment: Bool)
    func liked(status: Bool)
}
