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
    
    private let coreManager = CoreDataManager.shared
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "@\(self.user?.nickName ?? "nickNameHasntBeenSetUp")"
        label.setCustomStyle(style: .feedTitle)
        return label
    }()
    
    var userId: String
    
    private var user: UserData?
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(ProfileUserTableViewCell.self, forCellReuseIdentifier: ProfileUserTableViewCell.identifier)
        table.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.identifier)
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        table.delegate = self
        table.dataSource = self
        return table
    }()
    
    //MARK: - Lifecycle
    
    init(userId: String) {
        self.userId = userId
        self.user = coreManager.getUser(id: self.userId)!
        super.init(nibName: nil, bundle: nil)
        title = self.user?.nickName
        view.backgroundColor = .white
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        
        titleLabel.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(25)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.leading.equalTo(view.snp.leading).offset(20)
        }
        
        tableView.snp.makeConstraints {make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
        }
    }
}

//MARK: - TableViewDelegate and DataSource

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < 2 {
            return 1
        } else {
            return user?.posts?.count ?? 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = ProfileUserTableViewCell(userId: self.userId, reuseIdentifier: "UserCell")
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.identifier, for: indexPath) as? PhotosTableViewCell
            cell?.user = self.user!
            print("Coheared user \(user?.name)")
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell
            cell?.delegate = self
            let data = user?.posts
            let posts: [Post] = data?.allObjects as? [Post] ?? []
            cell?.postId = posts[indexPath.row].id
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
    func openPost(id: String) {
        coordinator?.ivent(action: .openPost(id: id), iniciator: self)
    }
    
    func openAuthor(id: String) {
        coordinator?.ivent(action: .showProfile(userId: id), iniciator: self)
    }

    func liked(status: Bool) {
        print("Liked tapped")
    }
}
