//
//  LikedViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 23.03.2023.
//

import UIKit
import SnapKit

class LikedViewController: UIViewController, CoordinatedProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    var likedPosts: [Post] = []
    
    let coreManager = CoreDataManager.shared
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor().background
        title = "Liked"~
        likedPosts = coreManager.getLikedPosts()
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        likedPosts = coreManager.getLikedPosts()
        print("LikedPosts = \(likedPosts.count)")
        tableView.reloadData()
    }
    // MARK: - Navigation



}

extension LikedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likedPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as! PostTableViewCell
        cell.post = likedPosts[indexPath.row]
        return cell
    }
    
    
}
