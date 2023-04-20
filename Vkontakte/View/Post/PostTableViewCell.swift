//
//  PostTableViewCell.swift
//  Vkontakte
//
//  Created by Simon Pegg on 03.03.2023.
//

import UIKit
import SnapKit

protocol PostTableViewCellDelegate: AnyObject {
    func openPost(source: Post)
    func openAuthor(user: UserData)
    func liked(status: Bool)
    func postMenuButtonTapped()
}

enum SetupOption {
    case bodyAndImage
    case onlyBody
    case onlyImage
    case onlyMain
}

class PostTableViewCell: UITableViewCell {
    
    var delegate: PostTableViewCellDelegate?
    
    let coreManager = CoreDataManager.shared
    
    static let identifier = "PostTableViewCell"
    
    var post: Post? {
        didSet {
            guard let post = post else {
                print("Post is nil in PostTableViewCell")
                return
            }
            userView.userId = post.author?.id
            title.text = post.title
            
            if post.body != nil && post.image != nil {
                setupWithOption(option: .bodyAndImage)
            } else if post.body != nil && post.image == nil {
                setupWithOption(option: .onlyBody)
            } else if post.body == nil && post.image != nil {
                setupWithOption(option: .onlyImage)
            } else {
                setupWithOption(option: .onlyMain)
            }
            setupLabel(label: self.likes, image: "heart", text: "\(post.likes )")
            setupLabel(label: self.comments, image: "bubble.middle.bottom", text: "\(post.commentsArray?.count ?? 0)")
            if post.author?.isLogged == true {
                addMenuButton()
            }
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
    
    private lazy var menuButton: UIButton = {
        let view = UIButton(image: UIImage(systemName: "ellipsis")!) {
            self.menuButtonTapped()
        }
        return view
    }()
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Setup
    
    private func setupWithOption(option: SetupOption) {
        addMain()
        switch option {
        case .bodyAndImage:
            addBodyAndImage()
        case .onlyBody:
            addBody()
        case .onlyImage:
            addImage()
        case .onlyMain:
            setupMainConstraints()
        }
    }
    
    private func addBodyAndImage() {
        contentView.addSubview(image)
        image.isUserInteractionEnabled = true
        image.image = coreManager.unpackPicture(picture: post!.image!)
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(bodyTapped))
        image.addGestureRecognizer(tapOnImage)
        body.text = post!.body
        contentView.addSubview(body)
        body.isUserInteractionEnabled = true
        contentView.addSubview(image)
        let tapOnBody = UITapGestureRecognizer(target: self, action: #selector(bodyTapped))
        body.addGestureRecognizer(tapOnBody)
        setupConstraints(option: .bodyAndImage)
    }
    
    private func addBody() {
        contentView.addSubview(body)
        body.isUserInteractionEnabled = true
        body.text = post!.body
        let tapOnBody = UITapGestureRecognizer(target: self, action: #selector(bodyTapped))
        body.addGestureRecognizer(tapOnBody)
        setupConstraints(option: .onlyBody)
    }
    
    private func addMain() {
        contentView.addSubview(userView)
        userView.isUserInteractionEnabled = true
        let tapOnUser = UITapGestureRecognizer(target: self, action: #selector(userTapped))
        userView.addGestureRecognizer(tapOnUser)
        contentView.addSubview(title)
        contentView.addSubview(likes)
        contentView.addSubview(comments)
        title.isUserInteractionEnabled = true
        likes.isUserInteractionEnabled = true
        comments.isUserInteractionEnabled = true
        let tapOnLikes = UITapGestureRecognizer(target: self, action: #selector(likesTapped))
        let tapOnComment = UITapGestureRecognizer(target: self, action: #selector(commentsTapped))
        let tapOnTitle = UITapGestureRecognizer(target: self, action: #selector(bodyTapped))
        title.addGestureRecognizer(tapOnTitle)
        likes.addGestureRecognizer(tapOnLikes)
        comments.addGestureRecognizer(tapOnComment)
        setupConstraints(option: .onlyMain)
    }
    
    private func addImage() {
        contentView.addSubview(image)
        image.isUserInteractionEnabled = true
        image.image = coreManager.unpackPicture(picture: post!.image!)
        let tapOnImage = UITapGestureRecognizer(target: self, action: #selector(bodyTapped))
        image.addGestureRecognizer(tapOnImage)
        setupConstraints(option: .onlyImage)
    }
    
    
    private func setupMainConstraints() {
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
        
        likes.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
            make.top.equalTo(title.snp.bottom).offset(5)
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
    
    private func setupConstraints(option: SetupOption) {
        
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
        
        switch option {
        case .bodyAndImage:
            image.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(10)
                make.centerX.equalTo(contentView.snp.centerX)
                make.width.equalTo(contentView.snp.width).offset(-40)
                make.height.equalTo(image.snp.width).multipliedBy(3.0 / 4.0)
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
        case .onlyBody:
            body.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(10)
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
            
        case .onlyImage:
            image.snp.makeConstraints { make in
                make.top.equalTo(title.snp.bottom).offset(10)
                make.centerX.equalTo(contentView.snp.centerX)
                make.width.equalTo(contentView.snp.width).offset(-40)
                make.height.equalTo(image.snp.width).multipliedBy(3.0 / 4.0)
            }
            likes.snp.makeConstraints { make in
                make.bottom.equalTo(contentView.snp.bottom).offset(-10)
                make.top.equalTo(image.snp.bottom).offset(5)
                make.height.equalTo(15)
                make.leading.equalTo(contentView.snp.leading).offset(20)
                make.width.equalTo(60)
            }
        case .onlyMain:
            print("")
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
    
    private func addMenuButton() {
        contentView.addSubview(menuButton)
        
        menuButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(10)
            make.width.equalTo(40)
        }
    }
    
    internal func menuButtonTapped() {
        delegate?.postMenuButtonTapped()
    }
    
    @objc private func bodyTapped() {
        guard (self.post != nil) else
        {
            print("Error to get PostId in PostTableViewCell")
            return
        }
        delegate?.openPost(source: post!)
    }
    
    @objc private func likesTapped() {
        updateLikes(state: true)
    }
    
    @objc private func userTapped() {
        guard (self.post != nil) else
        {
            print("Error to get PostId in PostTableViewCell")
            return
        }
        let author = post!.author
        guard let author = author else {
            return
        }
        delegate?.openAuthor(user: author)
    }
    
    @objc private func commentsTapped() {
        print("Comments tapped for PostTableViewCell")
        guard (self.post != nil) else
        {
            print("Error to get PostId in PostTableViewCell")
            return
        }
        self.delegate?.openPost(source: post!)
    }
    
    private func updateLikes(state: Bool) {
        if state == true {
            setupLabel(label: likes, image: "heart.fill", text: "\(post!.likes + 1)")
        } else {
            setupLabel(label: likes, image: "heart", text: "\(post!.likes - 1)")
        }
    }
}
