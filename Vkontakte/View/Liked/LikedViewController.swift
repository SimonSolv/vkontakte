//
//  LikedViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 23.03.2023.
//

import UIKit

class LikedViewController: UIViewController, CoordinatedProtocol {
    
    var coordinator: CoordinatorProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor().background
        title = "Liked"~
        // Do any additional setup after loading the view.
    }
    // MARK: - Navigation



}
