//
//  Protocol.swift
//  Vkontakte
//
//  Created by Simon Pegg on 15.03.2023.
//

protocol UserContainsProtocol {
    var userId: String { get set }
}

protocol PostTableViewCellDelegate {
    func openPost(id: String)
    func openAuthor(id: String)
    func liked(status: Bool)
}
