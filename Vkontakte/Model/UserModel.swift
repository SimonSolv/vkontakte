//
//  UserModel.swift
//  Vkontakte
//
//  Created by Simon Pegg on 02.03.2023.
//

import Foundation

struct User {
    let name: String
    let lastName: String?
    var fullName: String {
        return "\(name) \(lastName ?? "")"
    }
    var dateOfBirth: Date?
    let id: UUID
    var followers: Int?
    var friends: Int?
    var postsId: [String]?
    var nickName: String
    var pictures: [String]?
    var jobTitle: String?
}
