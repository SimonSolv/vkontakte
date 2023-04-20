//
//  CreatePostViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 25.03.2023.
//

import UIKit
import SnapKit
import CoreData

class CreatePostViewController: UIViewController, CoordinatedProtocol, UITextFieldDelegate {
    
    var coordinator: CoordinatorProtocol?
    
    private let coreManager = CoreDataManager.shared
    
    private var selectedImage: UIImage?
    
    private var titleText: String?
    
    private var bodyText: String?
    
    private let imagePicker = UIImagePickerController()
    
    private var postImage: Picture?
    
    private var postImageData: UIImage?
    
    // MARK: - Views
    
    private lazy var contentView = UIScrollView()
    
    private lazy var postImageView = UIImageView()

    private lazy var titleTextField: UITextView = {
        let view = UITextView()
        view.setStyle(.plain)
        view.delegate = self
        view.textColor = UIColor.systemGray
        view.text = "Enter title here..."
        return view
    }()
    
    private lazy var bodyTextField: UITextView = {
        let view = UITextView()
        view.setStyle(.plain)
        view.delegate = self
        view.textColor = UIColor.systemGray
        view.text = "Enter text here..."
        return view
    }()
    
    private lazy var addImageButton: UIButton = {
        let view = UIButton()
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.tintColor = .orange
        view.addSubview(imageView)
        view.addTarget(self, action: #selector(addImageTapped), for: .touchUpInside)
        return view
    }()
    
    private lazy var createPostButton: UIButton = {
        let view = UIButton()
        view.setCustomStyle(style: .orangeish)
        view.setTitle("Create", for: .normal)
        view.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return view
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create post"
        view.backgroundColor = .systemGray5
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationController?.navigationItem.rightBarButtonItem = cancelButton
        setupViews()
        setupConstraits()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    

    // MARK: - Setup

    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(bodyTextField)
        contentView.addSubview(addImageButton)
        contentView.addSubview(createPostButton)
    }
    
    private func setupConstraits() {
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
        }
        
//        contentView.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
//            make.leading.equalTo(view.snp.leading).offset(20)
//            make.trailing.equalTo(view.snp.trailing).offset(-20)
//            make.bottom.equalTo(view.snp.bottom)
//        }
        
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(50)
        }
        
        bodyTextField.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(300)
        }
        
        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(bodyTextField.snp.bottom).offset(20)
            make.width.equalTo(50)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(50)
        }
        
        createPostButton.snp.makeConstraints { make in
            make.top.equalTo(addImageButton.snp.bottom).offset(20)
            make.leading.equalTo(view.snp.leading).offset(20)
            make.trailing.equalTo(view.snp.trailing).offset(-20)
            make.height.equalTo(50)
            make.bottom.equalTo(contentView.snp.bottom)
        }
    }
    
    //MARK: - Methods
    
    @objc private func addImageTapped() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc private func cancelTapped() {
        
    }
    
    @objc private func createButtonTapped() {
        let picture = getPictureForPost()
        var bodyText: String? = nil
        if bodyTextField.text != "Enter text here..." {
            bodyText = bodyTextField.text
        }
        coreManager.createPost(title: titleTextField.text, body: bodyText, image: picture, authorId: coreManager.currentUser!.id!)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.sizeToFit()
    }
    
    func getPictureForPost() -> Picture? {
        var answer: Picture? = nil
        if let binaryData = postImageView.image?.jpegData(compressionQuality: 0.9) {
            answer = coreManager.savePicture(at: binaryData)
            
        }
        return answer
        
        
        
//        if imageURL != nil  {
//            let picture: Picture? = coreManager.checkExistance(picURL: imageURL!)
//            if picture != nil {
//                return picture
//            } else {
//                let picture = coreManager.createPicture(name: imageSaveName, path: imageURL!, user: coreManager.currentUser, album: nil)
//                return picture
//            }
//        } else {
//            print("Something is nil to create picture")
//            return nil
//        }
    }
    
    private func addImageView() {
        contentView.addSubview(postImageView)
        postImageView.backgroundColor = .green
        postImageView.contentMode = .scaleAspectFill
        if let addedImage = postImageData {
            postImageView.image = addedImage
        }
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(bodyTextField.snp.bottom).offset(20)
            make.leading.equalTo(contentView.snp.leading).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
        }
    }
}

extension CreatePostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let image = info[.originalImage] as? UIImage {
            self.postImageData = image
            self.addImageView()
        }
    }
}

extension CreatePostViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.bodyText = textView.text
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter text here..." || textView.text == "Enter title here..." {
            textView.text = ""
            textView.textColor = .black
        }
    }
}
