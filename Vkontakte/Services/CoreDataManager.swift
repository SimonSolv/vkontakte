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
    
    var defaultAvatar: Picture?
    
    var defaultPostPicture: Picture?
    
    static let shared = CoreDataManager()
    
    enum PostSorting {
        case date
        case author (user: UserData)
    }
    
    enum UserSorting {
        case name
        case isLogged
    }
    
    init() {
        createDefaults()
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
    
    func createDefaults() {
        if let path = Bundle.main.path(forResource: "DefaultAvatar", ofType: "jpg") {
            if let imageData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                self.defaultAvatar = savePicture(at: imageData)
            }
        }
        if let path = Bundle.main.path(forResource: "DefaultPostImage", ofType: "jpg") {
            if let imageData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                self.defaultPostPicture = savePicture(at: imageData)
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
    
    func createUser(name: String, lastName: String?, jobTitle: String, nickName: String, dateOfBirth: Date, avatar: Picture?, isLogged: Bool) {
        let newUser = UserData(context: persistentContainer.viewContext)
        newUser.id = UUID().uuidString
        newUser.name = name
        newUser.lastName = lastName
        newUser.jobTitle = jobTitle
        newUser.nickName = nickName
        newUser.dateOfBirth = dateOfBirth
        if avatar != nil {
            newUser.avatar = avatar!
            newUser.isLogged = isLogged
            saveContext()
            fetchUsers()
        }
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
    
    func editUserData(newData: [String?], avatar: UIImage? ) {
        for i in newData.indices {
            guard let value = newData[i] else {
                return
            }
            print(value)
            switch i {
            case 0:
                currentUser?.name = value
            case 1:
                currentUser?.lastName = value
            case 2:
                currentUser?.nickName = value
            case 3:
                currentUser?.jobTitle = value
            default:
                break
            }
        }
        if let newAvatar = avatar {
            currentUser?.avatar?.img = newAvatar.jpegData(compressionQuality: 0.9)
        }
        saveContext()
        fetchUsers()
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
    
    func getUsersSorted(by: UserSorting) -> [UserData] {
        switch by {
        case .isLogged:
            return users.sorted(by: {$0.isLogged && !$1.isLogged})
        case.name:
            return users.sorted(by: {$0.name! > $1.name!})
        }
    }
    
    func setUserOnline(user: UserData) {
        user.isLogged = true
        saveContext()
        fetchUsers()
    }
    
    func logOut() {
        currentUser?.isLogged = false
        saveContext()
        fetchUsers()
    }
    
    
    //MARK: - Posts
    
    func fetchPosts() {
        let request = Post.fetchRequest()
        let posts = (try? persistentContainer.viewContext.fetch(request)) ?? []
        self.posts = posts
    }
    
    func getSortedPosts(by: PostSorting?) -> [Post] {
        var answer: [Post] = []
        switch by {
        case .date:
            answer = self.posts.sorted(by: {$0.dateOfPublishing! > $1.dateOfPublishing!})
        default:
            return self.posts
        }
        return answer
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
    
    func createPost(title: String, body: String?, image: Picture?, authorId: String) -> Bool {
        let newPost = Post(context: persistentContainer.viewContext)
        newPost.id = UUID().uuidString
        guard image != nil else {
            print("No image for creating post")
            return false
        }
        newPost.image = image
        newPost.likes = Int64(arc4random_uniform(600))
        newPost.body = body
        newPost.title = title
        newPost.dateOfPublishing = Date(timeIntervalSinceNow: 0.0)
        guard let author = getUser(id: authorId) else {
            print("Couldnt get author")
            return false
        }
        newPost.author = author
        saveContext()
        fetchPosts()
        return true
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
    
    func fillPictures(names: [String]) -> [Picture] {
        var answer: [Picture] = []
        for name in names {
            
            if let path = Bundle.main.path(forResource: name, ofType: "jpg") {
                if let imageData = try? Data(contentsOf: URL(fileURLWithPath: path)) {
                    answer.append(savePicture(at: imageData))
                }
            }
        }
        return answer
    }
    
    func fetchPictures() {
        
    }
    
    func savePicture(at imgData: Data) -> Picture {
        let picture = Picture(context: persistentContainer.viewContext)
        picture.name = imageSaveName
        picture.img = imgData
        picture.user = currentUser
        saveContext()
        return picture
    }
    
//    func createPicture(name: String, path: URL, user: UserData?, album: Album?) -> Picture {
//        let picture = Picture(context: persistentContainer.viewContext)
//        picture.path = path
//        picture.name = name
//        if user != nil {
//            picture.user = user
//        }
//        if album != nil {
//            picture.album = album
//        }
//        saveContext()
//        return picture
//    }
    
    func unpackPicture(picture: Picture) -> UIImage? {
        var answer: UIImage?
        if let imageData = picture.img {
            answer = UIImage(data: imageData)
        }
        return answer
    }
    
//    func showPicture(url: URL) -> UIImage? {
//        var answer: UIImage?
//        do {
//            let imageData = try Data(contentsOf: url)
//            answer = UIImage(data: imageData)
//        } catch {
//            print("Ошибка при получении данных из файла: \(error)")
//        }
//        return answer
//    }
    
//    func checkExistance(picURL: URL) -> Picture? {
//        var answer: Picture? = nil
//        let request = Picture.fetchRequest()
//        let pictures = (try? persistentContainer.viewContext.fetch(request)) ?? []
//        for picture in pictures {
//            if picture.path == picURL {
//                answer = picture
//            }
//        }
//        return answer
//    }
    
    func getPicture(named: String) -> Picture? {
        var answer: Picture? = nil
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Picture> = Picture.fetchRequest()
        do {
            let pictures = try context.fetch(fetchRequest)
            for picture in pictures {
                while picture.name == named {
                    answer = picture
                }
            }
        } catch let error as NSError {
            print("Error fetching users: \(error), \(error.userInfo)")
        }
        return answer
    }
}
