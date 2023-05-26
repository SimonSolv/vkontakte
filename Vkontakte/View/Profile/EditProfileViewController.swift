//
//  EditProfileViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 24.03.2023.
//

import UIKit
import SnapKit

protocol EditProfileDelegate: AnyObject {
    func updateSideView()
}

class EditProfileViewController: UIViewController, CoordinatedProtocol, EditAvatarTableViewCellDelegate {
    
    var parentVC: ContainerViewController?
    
    var coordinator: CoordinatorProtocol?
    
    let coreManager = CoreDataManager.shared
    
    var delegate: EditProfileDelegate?
    
    var avatar: UIImage? = UIImage(data: (CoreDataManager.shared.currentUser?.avatar?.img)!)
    
    private lazy var saveButton: UIButton = {
        let view = UIButton()
        view.setTitle("Save"~, for: .normal)
        view.backgroundColor = .orange
        view.layer.cornerRadius = 15
        view.clipsToBounds = true
        view.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
        return view
    }()
    
    var user: UserData? {
        didSet {
            guard let user = user else {
                return
            }
            let name = user.name!
            let lastName = user.lastName ?? ""
            let job = user.jobTitle ?? ""
            let nickName = user.nickName!
            self.userInputs = [name, lastName, nickName, job]
        }
    }
    
    let fieldTitles = ["First Name"~, "Last Name"~, "Nick-name"~, "Job title"~]
    
    var userInputs: [String?] = []
    
    let tableView = UITableView()
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.user = coreManager.currentUser
        tableView.backgroundColor = .systemGray4
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(EditInfoTableViewCell.self, forCellReuseIdentifier: EditInfoTableViewCell.identifier)
        tableView.register(EditAvatarTableViewCell.self, forCellReuseIdentifier: EditAvatarTableViewCell.identifier)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "@\(user?.nickName ?? "")"
    }
    

    // MARK: - Setup
    
    private func setupView() {
        title = "Edit profile"~
        view.backgroundColor = .systemGray4
        view.addSubview(tableView)
        setupConstraits()
    }
    
    private func setupConstraits() {
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    //MARK: - Methods
    
    internal func editAvatarTapped() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            let imageData = try! Data(contentsOf: imageUrl)
            let image = UIImage(data: imageData)
            avatar = image
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - Table View Data Source

extension EditProfileViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return fieldTitles.count
        case 2:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditAvatarTableViewCell.identifier, for: indexPath) as! EditAvatarTableViewCell
            cell.delegate = self
            cell.data = avatar
            cell.contentView.backgroundColor = .systemGray4
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: EditInfoTableViewCell.identifier, for: indexPath) as! EditInfoTableViewCell
            cell.contentView.backgroundColor = .systemGray4
            cell.titleLabel.text = fieldTitles[indexPath.row]
            cell.textField.text = userInputs[indexPath.row]
            cell.textField.tag = indexPath.row - 1
            cell.textField.delegate = self
            return cell
        case 2:
            let cell = UITableViewCell(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 50)))
            let button = saveButton
            button.frame = CGRect(origin: CGPoint(x: super.view.bounds.midX - 150, y: 10), size: CGSize(width: 300, height: 50))
            cell.contentView.addSubview(button)
            cell.contentView.backgroundColor = .systemGray4
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @objc func saveButtonTapped() {
        let alert = UIAlertController(title: "Are you sure?"~, message: "This saves all changes"~, preferredStyle: .alert)
        let action = UIAlertAction(title: "Save"~, style: .cancel) { UIAlertAction in
            self.saveEdited()
            self.delegate!.updateSideView()
        }
        let cancelAction = UIAlertAction(title: "Cancel"~, style: .default)
        alert.addAction(cancelAction)
        alert.addAction(action)
        self.present(alert, animated: true)
        
    }
    private func saveEdited() {
        coreManager.editUserData(newData: userInputs, avatar: avatar)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - Table View Delegate

extension EditProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section > 0 {
            return 80
        }
        else {
            return 300
            //UITableView.automaticDimension
        }
    }
}

// MARK: - Text Field Delegate

extension EditProfileViewController: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        userInputs[textField.tag + 1] = textField.text ?? ""
    }
}



