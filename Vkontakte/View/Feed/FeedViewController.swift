//
//  FeedViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 03.03.2023.
//

import UIKit

class FeedViewController: UIViewController, CoordinatedProtocol {

    let coreManager = CoreDataManager.shared
    
    var coordinator: CoordinatorProtocol?
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.layer.backgroundColor = AppColor().background?.cgColor
        return table
    }()
    
    var refreshControl = UIRefreshControl()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor().background
        setupViews()
        setupConstraints()
        refreshControl.addTarget(self, action: #selector(updateTable), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        let notificationName = Notification.Name("ShowProfile")
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: notificationName, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        self.navigationController?.navigationBar.isUserInteractionEnabled = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Setup
    
    private func setupViews() {
        tableView.register(UsersCollectionHeaderView.self, forHeaderFooterViewReuseIdentifier: UsersCollectionHeaderView.identifier)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    private func setupConstraints() {
        tableView.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
    
    @objc func handleNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let id = userInfo["id"] as! String
            let user = coreManager.getUser(id: id)
            guard let user = user else { return }
            self.coordinator?.event(action: .showProfile(user: user), iniciator: self)
        }
    }
    
    @objc private func updateTable(sender: UIRefreshControl) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
}

//MARK: - TableViewDelegate

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coreManager.posts.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UsersCollectionHeaderView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        let source: [Post] = coreManager.getSortedPosts(by: .date)
        cell.contentView.backgroundColor = AppColor().background
        cell.backgroundColor = AppColor().background
        cell.post = source[indexPath.row]
        cell.delegate = self
        return cell
    }
    
//    @objc func handleTap(_ sender: CustomJestureRecognizer) {
//        let post = sender.post
//        guard post != nil else {
//            print ("Unexpected nil Post")
//            return
//        }
//        coreManager.addPost(post: post!)
//    }
}

extension FeedViewController: PostTableViewCellDelegate {
    func postLiked(state: Bool, post: Post) {
        if state == true {
            coreManager.addPost(post: post)
        }
    }
    
    
    func postMenuButtonTapped() {
        print("Tapped Menu")
    }
    
    func openPost(source: Post) {
        coordinator?.event(action: .openPost(post: source), iniciator: self)
    }
    
    func openAuthor(user: UserData) {
        coordinator?.event(action: .showProfile(user: user), iniciator: self)
    }
    
    func liked(status: Bool) {
        
    }
}
