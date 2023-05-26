//
//  LoginViewModel.swift
//  Vkontakte
//
//  Created by Simon Pegg on 11.03.2023.
//

import Foundation
import UIKit

enum AlertError: String {
    case wrongEmail = "Email is not correct!"
    case shortPassword = "Password should be at least 6 caracters!"
    case wrongPassword = "Password is incorrect"
    case userNotFound = "User not found"
}

class LoginInspector {

    var isLoggedIn: Bool = true
    
    func checkCredentials(email: String, password: String) -> Bool {
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func signUp (login: String, password: String, iniciator: UIViewController, realm: Bool) {

    }
}

