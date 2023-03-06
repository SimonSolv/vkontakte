//
//  FeedViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 03.03.2023.
//

import UIKit

class FeedViewController: UIViewController, CoordinatedProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    var storage = PostStorage()
    
    lazy var tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        setupViews()
        setupConstraints()
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
    
}

//MARK: - TableViewDelegate

extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return storage.posts.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UsersCollectionHeaderView()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell
//        let doubleTapp = CustomJestureRecognizer(target: self, action: #selector(ProfileViewController.handleTap(_:)))
//        doubleTapp.numberOfTapsRequired = 2
//        doubleTapp.post = cellPost
//        cell?.addGestureRecognizer(doubleTapp)
        cell?.delegate = self
        cell?.source = storage.posts[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        let controller = PostViewController()
        controller.source = storage.posts[indexPath.row]
        self.present(controller, animated: true)
        self.navigationController?.pushViewController(controller, animated: true)
    }

}

extension FeedViewController: PostTableViewCellDelegate {
    func openPost(comment: Bool) {
        self.coordinator?.ivent(action: .openPost, iniciator: self)
    }
    
    func liked(status: Bool) {
        print("Liked tapped")
    }
    
    
}
