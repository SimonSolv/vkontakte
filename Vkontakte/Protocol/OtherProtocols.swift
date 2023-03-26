//
//  Protocol.swift
//  Vkontakte
//
//  Created by Simon Pegg on 15.03.2023.
//

protocol UserContainsProtocol {
    var userId: String { get set }
}

protocol PostTableViewCellDelegate: AnyObject {
    func openPost(source: Post)
    func openAuthor(id: String)
    func liked(status: Bool)
}

protocol ProfileUserViewDelegate: AnyObject {
    func additionalInfoTapped(id: String)
    func messageButtonTapped(id: String)
    func editButtonTapped(id: String)
    func postsTapped(id: String)
    func subscribersTapped(id: String)
    func subscriptionsTapped(id: String)
}

protocol PostsHeaderTableViewCellDelegate {
    func createPost()
}

protocol ProfileViewControllerDelegate: AnyObject {
    func menuButtonTapped()
}

protocol SideMenuViewControllerDelegate: AnyObject {
    func likedTapped()
    func settingsTapped()
    func logOutTapped()
    func galleryTapped()
}

