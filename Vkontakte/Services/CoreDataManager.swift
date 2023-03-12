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
    
    init() {
        fetchUsers()
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
    
 //   var pictures: [Picture] = []
    
    func fetchUsers() {
        let request = UserData.fetchRequest()
        let users = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.users = users
    }
    
    func createUser(name: String, lastName: String?, jobTitle: String, nickName: String, dateOfBirth: Date, avatar: String?) {
        var newUser = UserData(context: persistentContainer.viewContext)
        newUser.id = UUID().uuidString
        newUser.name = name
        newUser.lastName = lastName
        newUser.jobTitle = jobTitle
        newUser.nickName = nickName
        newUser.dateOfBirth = dateOfBirth
        newUser.avatar = avatar ?? "DefaultAvatar"
        saveContext()
        fetchUsers()
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
                print("Error: Cannot find user via id provided")
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
                print("Error: Cannot find user via id provided")
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
    
    
    //MARK: - Posts
    
    func fetchPosts() {
        let request = Post.fetchRequest()
        let posts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.posts = posts
    }
    
    func createPost(title: String, body: String, image: String, authorId: String) {
        var newPost = Post(context: persistentContainer.viewContext)
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
                print("Error: Cannot find post via id provided")
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
                print("Error: Cannot find user via id provided")
            }
        }
    }
    
    func getPost(id: String) -> Post? {
        var data: Post? = Post()
        for post in posts {
            if post.id == id {
                data = post
            } else {
                print("Error: Cannot find user via id provided")
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
}
