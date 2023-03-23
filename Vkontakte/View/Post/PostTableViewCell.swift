//
//  PostTableViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 03.03.2023.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    var delegate: PostTableViewCellDelegate?
    
    let coreManager = CoreDataManager.shared
    
    static let identifier = "PostTableViewCell"
    
    var post: Post?
    
    var postId: String? {
        didSet {
            guard let source = coreManager.getPost(id: postId!) else {
                print ("Couldnt get post in PostTableViewCell")
                return
            }
            post = source
            userView.userId = source.author?.id
            title.text = source.title
            body.text = source.body
            image.image = UIImage(named: source.image ?? "DefaultPostImage")
            setupLabel(label: self.likes, image: "heart", text: "\(source.likes )")
            setupLabel(label: self.comments, image: "bubble.middle.bottom", text: "\(source.commentsArray?.count ?? 0)")
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
        let tapOnLikes = UITapGestureRecognizer(target: self, action: #selector(likesTapped))
        let tapOnComment = UITapGestureRecognizer(target: self, action: #selector(commentsTapped))
        let tapOnUser = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        let tapOnBody = UITapGestureRecognizer(target: self, action: #selector(bodyTapped))
        let tapOnTitle = UITapGestureRecognizer(target: self, action: #selector(bodyTapped))
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(bodyTapped))
        userView.avatar.addGestureRecognizer(tapOnUser)
        body.addGestureRecognizer(tapOnBody)
        image.addGestureRecognizer(tapOnImage)
        title.addGestureRecognizer(tapOnTitle)
        likes.addGestureRecognizer(tapOnLikes)
        comments.addGestureRecognizer(tapOnComment)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    private func setupViews() {
        contentView.addSubview(userView)
        contentView.addSubview(title)
        contentView.addSubview(body)
        contentView.addSubview(image)
        contentView.addSubview(likes)
        contentView.addSubview(comments)
        userView.isUserInteractionEnabled = true
        body.isUserInteractionEnabled = true
        image.isUserInteractionEnabled = true
        title.isUserInteractionEnabled = true
        likes.isUserInteractionEnabled = true
        comments.isUserInteractionEnabled = true
    }
    
    private func setupConstraints() {
        
        userView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(75)
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
    
    @objc private func bodyTapped() {
        print("Body tapped for PostTableViewCell")
        guard (self.postId != nil) else
        {
            print("Error to get PostId in PostTableViewCell")
            return
        }
        delegate?.openPost(id: postId!)
    }
    
    @objc private func likesTapped() {
        updateLikes(state: true)
    }
    
    @objc private func userTapped() {
        print("User tapped for PostTableViewCell")
        guard (self.postId != nil) else
        {
            print("Error to get PostId in PostTableViewCell")
            return
        }
        let coreManager = CoreDataManager.shared
        let post = coreManager.getPost(id: postId!)
        let author = post!.author
        delegate?.openAuthor(id: (author?.id)!)
    }
    
    @objc private func commentsTapped() {
        print("Comments tapped for PostTableViewCell")
        guard (self.postId != nil) else
        {
            print("Error to get PostId in PostTableViewCell")
            return
        }
        self.delegate?.openPost(id: postId!)
    }
    
    private func updateLikes(state: Bool) {
        if state == true {
            setupLabel(label: likes, image: "heart.fill", text: "\(post!.likes + 1)")
        } else {
            setupLabel(label: likes, image: "heart", text: "\(post!.likes - 1)")
        }
    }
}
