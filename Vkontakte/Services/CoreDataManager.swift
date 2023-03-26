//
//  CoreDataManager.swift
//  Vkontakte
//
//  Created by Simon Pegg on 07.03.2023.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    enum UserSorting {
        case name
        case isLogged
    }
    
    init() {
        fetchUsers()
        fetchPosts()
        fetchComments()
        self.currentUser = getCurrentUser()
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Vkontakte")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    //MARK: - CoreData saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    //MARK: - Users
    
    var users: [UserData] = []
    
    var posts: [Post] = []
    
    var comments: [Comment] = []
    
    var currentUser: UserData?
    
    var pictures: [Picture] = []
    
    func fetchUsers() {
        let request = UserData.fetchRequest()
        let users = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.users = users
    }
    
    func createUser(name: String, lastName: String?, jobTitle: String, nickName: String, dateOfBirth: Date, avatar: String?, isLogged: Bool) {
        let newUser = UserData(context: persistentContainer.viewContext)
        newUser.id = UUID().uuidString
        newUser.name = name
        newUser.lastName = lastName
        newUser.jobTitle = jobTitle
        newUser.nickName = nickName
        newUser.dateOfBirth = dateOfBirth
        if avatar == "" || avatar == nil {
            newUser.avatar = "DefaultAvatar"
        } else {
            newUser.avatar = avatar!
        }
        newUser.isLogged = isLogged
        saveContext()
        fetchUsers()
    }
    
    func getCurrentUser() -> UserData? {
        var answer: UserData?
        for user in users {
            if user.isLogged == true {
                answer = user
            }
        }
        return answer
    }
    
    func editUserData(userId: String, newData: UserData) {
        for user in users {
            if user.id == userId {
                user.name = user.name
                user.lastName = user.lastName
                user.jobTitle = user.jobTitle
                user.nickName = user.nickName
                user.dateOfBirth = user.dateOfBirth
                saveContext()
                fetchUsers()
            } else {
                print("Error: Cannot find user via id provided in EditUserData")
            }
        }
    }
    
    func deleteUser(userId: String) {
        for user in users {
            if user.id == userId {
                persistentContainer.viewContext.delete(user)
                saveContext()
                fetchUsers()
            } else {
                print("Error: Cannot find user via id provided in deleteUser")
            }
        }
    }
    
    func getUser(id: String) -> UserData? {
        var data: UserData? = nil
        for user in users {
            if user.id == id {
                data = user
            }
        }
        return data
    }
    
    func getUserByNick (nickName: String) -> UserData? {
        var data: UserData? = nil
        for user in users {
            if user.nickName == nickName {
                data = user
            }
        }
        return data
    }
    
    func getUserByName(name: String) -> UserData? {
        fetchUsers()
        var data: UserData? = nil
        for user in users {
            if user.name == name {
                data = user
            }
        }
        return data
    }
    
    func setCurrentUser(id: String) {
        self.currentUser = getUser(id: id)
    }
    
    func getUsersSorted(by: UserSorting) -> [UserData] {
        switch by {
        case .isLogged:
            return users.sorted(by: {$0.isLogged && !$1.isLogged})
        case.name:
            return users.sorted(by: {$0.name! > $1.name!})
        }
    }
    
    
    //MARK: - Posts
    
    func fetchPosts() {
        let request = Post.fetchRequest()
        let posts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.posts = posts
    }
    
    func fetchPostsFor(user id: String) -> [Post] {
        var answer: [Post] = []
        for post in self.posts {
            if post.author?.id == id {
                answer.append(post)
            }
        }
        return answer
    }
    
    func createPost(title: String, body: String, image: String, authorId: String) {
        let newPost = Post(context: persistentContainer.viewContext)
        newPost.id = UUID().uuidString
        newPost.image = image
        newPost.likes = Int64(arc4random_uniform(600))
        newPost.body = body
        newPost.title = title
        newPost.dateOfPublishing = Date()
        newPost.author = getUser(id: authorId)
        saveContext()
        fetchPosts()
    }
    
    func editPost(postId: String, newData: Post) {
        for post in posts {
            if post.id == postId {
                post.title = newData.title
                post.image = newData.image
                post.body = newData.body
                post.dateOfPublishing = Date()
                saveContext()
                fetchPosts()
            } else {
                print("Error: Cannot find post via id provided in editPost")
            }
        }
    }
    
    func deletePost(postId: String) {
        for post in posts {
            if post.id == postId {
                persistentContainer.viewContext.delete(post)
                saveContext()
                fetchPosts()
            } else {
                print("Error: Cannot find post via id provided in deletePost")
            }
        }
    }
    
    func getPost(id: String) -> Post? {
        fetchPosts()
        var data: Post?
        print("\(posts.count)")
        for post in posts {
            if post.id == id {
                data = post
            } else {
                print("Error: Cannot find post via id provided in getPost")
                print ("Id provided: \(id)")
                data = nil
            }
        }
        return data
    }
    
    
    //MARK: - Comments
    
    func fetchComments() {
        let request = Post.fetchRequest()
        let posts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.posts = posts
    }
    
    func addComment(postId: String, authorId: String, body: String) {
        let comment = Comment(context: persistentContainer.viewContext)
        comment.id = UUID().uuidString
        comment.body = body
        comment.author = getUser(id: authorId)
        comment.post = getPost(id: postId)
        saveContext()
        fetchComments()
    }
    
    func editComment(commentId: String, newBody: String) {
        for comment in comments {
            if comment.id == commentId {
                comment.body = newBody
                saveContext()
                fetchComments()
            } else {
                print("Error: Cannot find comment via id provided")
            }
        }
    }
    
    func deleteComment(commentId: String) {
        for comment in comments {
            if comment.id == commentId {
                persistentContainer.viewContext.delete(comment)
                saveContext()
                fetchComments()
            } else {
                print("Error: Cannot find comment via id provided")
            }
        }
    }
    
    //MARK: - Pictures
    
//    func createPicture(url: URL, name: String, user: UserData?, album: Album?) {
//        let picture = Picture(context: persistentContainer.viewContext)
//        picture.url = url
//        picture.name = name
//        if user != nil {
//            picture.user = user
//        }
//        if album != nil {
//            picture.album = album
//        }
//        saveContext()
//    }
}
