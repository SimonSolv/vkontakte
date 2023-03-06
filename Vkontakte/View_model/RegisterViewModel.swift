//
//  RegisterViewModel.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import Foundation

class PersonViewModel {
    private let user: User
    
    init(user: User) {
        self.user = user
    }
    
    var fullName: String {
        return user.fullName
    }
}

class RegisterViewModel {
    func checkConfirmationCode(code: String?) -> Bool {
        guard code != nil else {
            return false
        }
        if code?.count == 4 {
            if code == "0000" {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
}
