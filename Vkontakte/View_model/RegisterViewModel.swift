//
//  RegisterViewModel.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import Foundation
import UIKit

//class PersonViewModel {
//    
//    private let user: UserData?
//    
//    let coreManager = CoreDataManager.shared
//    
//    var userId: String
//    
//    init(userId: String) {
//        self.user = coreManager.getUser(id: userId)
//    }
//    
//    var fullName: String {
//        let myUser = self.user
//        if myUser != nil {
//            return "\(myUser!.name) \(myUser?.lastName ?? "")"
//        }
//        return ""
//    }
//}

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

