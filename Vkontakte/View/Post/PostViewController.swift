//
//  PostViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 05.03.2023.
//

import UIKit
import SnapKit

class PostViewController: ThemeViewController, CoordinatedProtocol, PostTableViewCellDelegate {
    
    var coordinator: CoordinatorProtocol?
    
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    let coreManager = CoreDataManager.shared
    
    var post: Post? {
        didSet {
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
            image.image = coreManager.unpackPicture(picture: post.image!) ?? UIImage(named: "DefaultPostImage")!
            body.text = post.body
            setupLabel(label: self.likes, image: "heart", text: "\(post.likes )")
            
            setupLabel(label: self.comments, image: "bubble.middle.bottom", text: "\(post.commentsArray?.count ?? 0)")
            if post.author?.isLogged == true {
                addMenuButton()
            }
        }
    }
    
    var authorId: String?
    
    private var userView: UserView = UserView()
    
    private lazy var postTitle: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedTitle)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var body: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var likes: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        return label
    }()
    
    private lazy var comments: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedBody)
        return label
    }()
    
    private lazy var menuButton: UIButton = {
        let view = UIButton(image: UIImage(systemName: "ellipsis")!) {
            self.postMenuButtonTapped()
        }
        return view
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor().background
        setupViews()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.backItem?.title = "Feed"~
        self.navigationController?.navigationBar.tintColor = .orange
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
            //make.height.greaterThanOrEqualTo(scrollView.snp.height)
            make.trailing.equalTo(scrollView.snp.trailing)
            make.leading.equalTo(scrollView.snp.leading)
            make.top.equalTo(scrollView.snp.top)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        userView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(10)
            make.leading.equalTo(contentView.snp.leading).offset(15)
            make.trailing.equalTo(contentView.snp.trailing).offset(-15)
        }
        
        postTitle.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(75)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.trailing.equalTo(contentView.snp.trailing).offset(-20)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalTo(postTitle.snp.bottom).offset(10)
            make.centerX.equalTo(contentView.snp.centerX)
            make.width.equalTo(contentView.snp.width).offset(-40)
            make.height.equalTo(image.snp.width).multipliedBy(3.0 / 4.0)
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
    
    private func addMenuButton() {
        contentView.addSubview(menuButton)
        
        menuButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-15)
            make.height.equalTo(10)
            make.width.equalTo(40)
        }
    }
    
    internal func postMenuButtonTapped() {
        print("TappedMenu")
    }
    
    @objc private func likesTapped() {
        updateLikes(state: true)
    }
    
    @objc private func commentsTapped() {
        
    }
    
    private func updateLikes(state: Bool) {
        
    }
    
    func openPost(source post: Post) {
        self.coordinator?.event(action: .openPost(post: post), iniciator: self)
    }
    
    func openAuthor(user: UserData) {
        self.coordinator?.event(action: .showProfile(user: user), iniciator: self)
    }
    
    func liked(status: Bool) {
        
    }
    
    func postLiked(state: Bool, post: Post) {
        if state == true {
            coreManager.addPost(post: post)
        }
    }
}

