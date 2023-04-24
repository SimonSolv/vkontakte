//
//  ThemeViewController.swift
//  Vkontakte
//
//  Created by Simon Pegg on 23.04.2023.
//

import UIKit

open class ThemeViewController: UIViewController {
    
    public var uiStyle: UIUserInterfaceStyle = .light

    open override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = uiStyle
    }
    

}
