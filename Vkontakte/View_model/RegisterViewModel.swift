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

//func createUser(user: User) {
// 
//    let appDelegate = UIApplication.shared.delegate as! AppDelegate
//    let managedContext = appDelegate.persistentContainer.viewContext
//    let userID = UUID().uuidString
//    let newUser = UserData(context: managedContext)
//    newUser.name = user.name
//    newUser.lastName = user.lastName
//    newUser.nickName = user.nickName
//    newUser.jobTitle = user.jobTitle
//    newUser.id = userID
//    
//    do {
//        try managedContext.save()
//    } catch let error as NSError {
//        print("Could not save. \(error), \(error.userInfo)")
//    }
//}
