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
        return table
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
        setupConstraints()
        let notificationName = Notification.Name("ShowProfile")
        // Add observer for the notification
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: notificationName, object: nil)
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
    
    //Handle notification to open profile when tapped on user in collectionView
    @objc func handleNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let id = userInfo["id"] as! String
            self.coordinator?.ivent(action: .showProfile(id: id), iniciator: self)
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
        let id = coreManager.posts[indexPath.row].id
        guard let id = id else {
            print("Id, transfered to cell is nil in FeedViewController")
            print("Id is \(id)")
            return UITableViewCell()
        }
        cell.postId = id
        cell.delegate = self
        return cell
    }

}

extension FeedViewController: PostTableViewCellDelegate {
    func openPost(id: String) {
        coordinator?.ivent(action: .openPost(id: id), iniciator: self)
    }
    
    func openAuthor(id: String) {
        coordinator?.ivent(action: .showProfile(id: id), iniciator: self)
    }
    
    func liked(status: Bool) {
        
    }
}
