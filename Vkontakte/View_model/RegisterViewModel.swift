//
//  RegisterViewModel.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import Foundation

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

