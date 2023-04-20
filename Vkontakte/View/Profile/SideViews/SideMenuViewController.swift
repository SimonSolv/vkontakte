//
//  SideMenuViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 26.03.2023.
//

import UIKit

protocol SideMenuViewControllerDelegate: AnyObject {
    func didSelect(menuItem: SideMenuViewController.MenuOptions)
    func showProfile()
}

class SideMenuViewController: UIViewController {
    
    weak var delegate: SideMenuViewControllerDelegate?
    
    enum MenuOptions: String, CaseIterable {
        
        case home = ""
        case liked = "Liked posts"
        case photos = "PhotoGallery"
        case settings = "Settings"
        case logOut = "Log out"
        
        var imageName: String {
            switch self {
            case .liked:
                return "heart.fill"
            case .photos:
                return "photo.on.rectangle.angled"
            case .settings:
                return "gear"
            case .logOut:
                return "rectangle.portrait.and.arrow.right"
            case.home:
                return ""
            }
        }
    }
    
    private lazy var userView: UserView = {
        let view = UserView()
        view.backgroundColor = .systemGray4
        view.userId = CoreDataManager.shared.currentUser?.id
        view.job.textColor = .black
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private lazy var tableView: UITableView = {
        let view = UITableView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.register(UITableViewCell.self, forCellReuseIdentifier: "userCell")
        view.backgroundColor = nil
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
        tableView.frame = CGRect(origin: CGPoint(x: 120, y: view.safeAreaInsets.top + 25), size: CGSize(width: view.bounds.size.width, height: view.bounds.size.height))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

//MARK: - TableViewDelegate / DataSource

extension SideMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
            cell.contentView.addSubview(userView)
            cell.backgroundColor = .systemGray4
            cell.contentView.backgroundColor = nil
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = MenuOptions.allCases[indexPath.row].rawValue
            cell.imageView?.image = UIImage(systemName: MenuOptions.allCases[indexPath.row].imageName)
            cell.imageView?.tintColor = .black
            cell.backgroundColor = .systemGray4
            cell.contentView.backgroundColor = nil
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let menuItem = MenuOptions.allCases[indexPath.row]
        delegate?.didSelect(menuItem: menuItem)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        } else {
            return 50
        }
    }

}
