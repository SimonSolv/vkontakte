//
//  PostViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 05.03.2023.
//

import UIKit

class PostViewController: UIViewController, CoordinatedProtocol, PostTableViewCellDelegate {

    var coordinator: CoordinatorProtocol?
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    var postId: String? {
        didSet {
            let coreManager = CoreDataManager.shared
            guard postId != nil else {
                print("Couldnt set postId in PostViewController")
                return
            }
            let post = coreManager.getPost(id: postId!)
            guard let post = post else {
                print("Couldnt find post via id provided in PostViewController")
                return
            }
            userView = {
                let view = UserView()
                view.userId = post.author?.id
                return view
            }()
            postTitle.text = post.title
            image.image = UIImage(named: post.image ?? "DefaultPostImage")
            body.text = post.body
            setupLabel(label: self.likes, image: "heart", text: "\(post.likes )")
            
            setupLabel(label: self.comments, image: "bubble.middle.bottom", text: "\(post.commentsArray?.count ?? 0)")
        }
    }
    
    var authorId: String?
    
    var userView: UserView = UserView()
    
    lazy var postTitle: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedTitle)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var body: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        label.numberOfLines = 0
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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        setupConstraints()
    }
    
    //MARK: - Setup
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(userView)
        contentView.addSubview(postTitle)
        contentView.addSubview(body)
        contentView.addSubview(image)
        contentView.addSubview(likes)
        contentView.addSubview(comments)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likesTapped))
        likes.addGestureRecognizer(tapGesture)
        comments.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.width.equalTo(scrollView.snp.width)
            make.height.greaterThanOrEqualTo(scrollView.snp.height)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.leading.equalTo(scrollView.snp.leading)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        userView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.leading.equalTo(contentView.snp.leading)
            make.trailing.equalTo(contentView.snp.trailing)
        }
        
        postTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(70)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalTo(postTitle.snp.bottom).offset(10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).offset(-40)
           // make.height.equalTo(postTitle.snp.width).multipliedBy(3/4)
            make.height.equalTo(200)
        }
        
        body.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
        
        likes.snp.makeConstraints { make in
            
            make.top.equalTo(body.snp.bottom).offset(5)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.width.equalTo(60)
        }
        
        comments.snp.makeConstraints { make in
            make.top.equalTo(likes.snp.top)
            make.leading.equalTo(contentView.snp.leading).offset(85)
            make.width.equalTo(60)
            make.bottom.equalTo(contentView.snp.bottom).offset(-10)
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
        
    }
    
    private func updateLikes(state: Bool) {
        
    }
    
    func openPost(id: String) {
        self.coordinator?.ivent(action: .openPost(id: id), iniciator: self)
    }
    
    func openAuthor(id: String) {
        self.coordinator?.ivent(action: .showProfile(id: id), iniciator: self)
    }
    
    func liked(status: Bool) {
        
    }
}

