//
//  AdditionalInfoViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 21.03.2023.
//

import UIKit
import SnapKit

class AdditionalInfoViewController: UIViewController, CoordinatedProtocol {
    
    var coordinator: CoordinatorProtocol?
    
    var user: UserData? {
        didSet {
            guard let user = user else {
                print("User ir (nil) in AdditionalViewController")
                return
            }
            setupView()
            setupData(user: user)
        }
    }
    
    var scroll = UIScrollView()
    
    private lazy var avatar: UIImageView = {
        let view = UIImageView()
        view.isUserInteractionEnabled = true
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var name: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .feedTitle)
        return label
    }()
    
    private lazy var job: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .grayBig)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var dateOfBirth: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .miniTitle)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var city: UILabel = {
        let label = UILabel()
        label.setCustomStyle(style: .miniTitle)
        label.numberOfLines = 2
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Methods

    private func setupView() {
        view.addSubview(scroll)
        scroll.addSubview(avatar)
        scroll.addSubview(name)
        scroll.addSubview(job)
        scroll.addSubview(dateOfBirth)
        scroll.addSubview(city)
        setupConstraints()
    }
    
    private func setupData(user: UserData) {
        avatar.image = CoreDataManager.shared.unpackPicture(picture: user.avatar!)
        avatar.layer.cornerRadius = 15
        avatar.clipsToBounds = true
        name.text = "\(user.name ?? "User") \(user.lastName ?? "")"
        job.text = "Job title \n\(user.jobTitle ?? "Unknown")"
        
        //formate date to show in view
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        if user.dateOfBirth != nil {
            let dateString = dateFormatter.string(from: user.dateOfBirth!)
            dateOfBirth.text = "Date of birth\n\(dateString)"
        } else {
            dateOfBirth.text = "Date of birth\n Unknown"
        }
        
        if user.city != nil {
            city.text = "City:\n\(user.city!)"
        } else {
            city.text = "City:\nUnknown"
        }
    }
    
    private func setupConstraints() {
        scroll.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
        }
        
        avatar.snp.makeConstraints { make in
            make.top.equalTo(scroll.snp.top).offset(5)
            make.height.equalTo(150)
            make.centerX.equalTo(scroll.snp.centerX)
            make.leading.equalTo(scroll.snp.leading).offset(5)
            make.trailing.equalTo(scroll.snp.trailing).offset(-5)
        }
        
        name.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(10)
            make.leading.equalTo(scroll.snp.leading).offset(25)
            make.trailing.equalTo(scroll.snp.trailing).offset(-25)
        }
        
        job.snp.makeConstraints { make in
            make.top.equalTo(name.snp.bottom).offset(10)
            make.leading.equalTo(scroll.snp.leading).offset(25)
            make.trailing.equalTo(scroll.snp.trailing).offset(-25)
        }
        
        city.snp.makeConstraints { make in
            make.top.equalTo(job.snp.bottom).offset(10)
            make.leading.equalTo(scroll.snp.leading).offset(25)
            make.trailing.equalTo(scroll.snp.trailing).offset(-25)
        }
        
        dateOfBirth.snp.makeConstraints { make in
            make.top.equalTo(city.snp.bottom).offset(10)
            make.leading.equalTo(scroll.snp.leading).offset(25)
            make.trailing.equalTo(scroll.snp.trailing).offset(-25)
        }
    }
    
}
