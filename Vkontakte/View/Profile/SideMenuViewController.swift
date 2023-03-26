//
//  SideMenuViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 26.03.2023.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    enum MenuOptions: String, CaseIterable {
        case liked = "Liked posts"
        case photos = "PhotoGallery"
        case settings = "Settings"
        case logOut = "Log out"
    }
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.backgroundColor = .clear
        return view
    }()
 
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray4
        view.addSubview(tableView)
        view.layer.shadowRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(origin: CGPoint(x: 120, y: view.safeAreaInsets.top), size: CGSize(width: view.bounds.size.width, height: view.bounds.size.height))
    }
}

//MARK: - TableViewDelegate / DataSource

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
        cell.contentView.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
