//
//  ProfileViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 06.03.2023.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController, CoordinatedProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    private lazy var header: ProfileUserView = {
        let view = ProfileUserView()
        let coreManager = CoreDataManager.shared
        view.user = coreManager.getUserByName(name: "Kate")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    private func setupView() {
        view.addSubview(header)
    }
    
    private func setupConstraints() {
        header.snp.makeConstraints {make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(300)
            make.trailing.equalTo(view.snp.trailing)
            make.leading.equalTo(view.snp.leading)
        }
    }



}
