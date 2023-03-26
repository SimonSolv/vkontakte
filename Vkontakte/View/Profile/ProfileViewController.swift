//
//  ProfileViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 06.03.2023.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController, CoordinatedProtocol, UserContainsProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    weak var delegate: ProfileViewControllerDelegate?
    
    private let coreManager = CoreDataManager.shared
    
    var userId: String
    
    private var user: UserData?
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ProfileUserTableViewCell.self, forCellReuseIdentifier: ProfileUserTableViewCell.identifier)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        table.register(PostsHeaderTableViewCell.self, forCellReuseIdentifier: PostsHeaderTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    //MARK: - Lifecycle
    
    init(userId: String) {
        self.userId = userId
        self.user = coreManager.getUser(id: self.userId)!
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        self.title = "@\(self.user?.nickName ?? "nickName")"
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if user?.isLogged == false {
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.backItem?.title = "Feed"
            self.navigationController?.navigationBar.tintColor = .orange
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal"), style: .done, target: self, action: #selector(menuButtonTapped))
            self.navigationController?.navigationBar.isHidden = false
            // Disable swipe-to-go-back gesture in the current view controller
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
        
    }
    
    //MARK: - Setup
    
    private func setupView() {
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        
        tableView.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
        }
    }
    
    @objc private func menuButtonTapped() {
        self.delegate?.menuButtonTapped()
    }
}

//MARK: - TableViewDelegate and DataSource

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 3 {
            return 1
        } else {
            return user?.posts?.count ?? 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: ProfileUserTableViewCell.identifier) as? ProfileUserTableViewCell
            cell?.id = self.userId
            cell?.delegate = self
            return cell!
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as? PhotosTableViewCell
            cell?.user = self.user!
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostsHeaderTableViewCell.identifier, for: indexPath) as? PostsHeaderTableViewCell
            cell?.user = self.user
            cell?.delegate = self
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell
            var posts: [Post] = []
            posts = coreManager.fetchPostsFor(user: userId)
            cell?.delegate = self
            cell?.post = posts[indexPath.row]
            return cell!
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected")
//        let controller = PostViewController()
//        controller.source = coreManager.posts[indexPath.row]
//        self.present(controller, animated: true)
//        self.navigationController?.pushViewController(controller, animated: true)
//    }

}

extension ProfileViewController: PostTableViewCellDelegate {
    
    func openPost(source: Post) {
        coordinator?.ivent(action: .openPost(post: source), iniciator: self)
    }
    
    func openAuthor(id: String) {
        //coordinator?.ivent(action: .showProfile(id: id), iniciator: self)
    }

    func liked(status: Bool) {
        print("Liked tapped")
    }
}

extension ProfileViewController: ProfileUserViewDelegate, PostsHeaderTableViewCellDelegate {
    
    func createPost() {
        coordinator?.ivent(action: .createPostTapped, iniciator: self)
    }
    
    
    func additionalInfoTapped(id: String) {
        coordinator?.ivent(action: .showAdditionalInfo(id: userId), iniciator: self)
    }
    
    func messageButtonTapped(id: String) {
        coordinator?.ivent(action: .messageTapped, iniciator: self)
    }
    
    func editButtonTapped(id: String) {
        print("Edit tapped")
    }
    
    func postsTapped(id: String) {
        print("Posts tapped")
    }
    
    func subscribersTapped(id: String) {
        print("Subscribers tapped")
    }
    
    func subscriptionsTapped(id: String) {
        print("Subscriptions tapped")
    }
    
}
