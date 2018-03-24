//
//  Datastore.swift
//  incognito
//
//  Created by yang zhong on 3/3/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import Foundation
import Firebase

class DataStore {
    
    // Instantiate the singleton object.
    static let shared = DataStore()
    static let storage = Storage.storage()

    private var ref: DatabaseReference!
    
    private var Users: [User]!
    private var Posts: [Post]!
    private var Comments: [Comment]!
    // Making the init method private means only this class can instantiate an object of this type.
    private init() {
        // Get a database reference.
        // Needed before we can read/write to/from the firebase database.
        ref = Database.database().reference()
    }
    
    func getUser(index: Int) -> User {
        return Users[index]
    }
    
    func loadUser() {
        // Start with an empty array of User objects.
        Users = [User]()
        
        // Fetch the data from Firebase and store it in our internal people array.
        // This is a one-time listener.
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get the top-level dictionary.
            let value = snapshot.value as? NSDictionary
            
            if let users = value {
                // Iterate over the person objects and store in our internal people array.
                for p in users {
                    let id = p.key as! String
                    let user = p.value as! [String:Any]
                    let username = user["username"]
                    let password = user["password"]
                    let email = user["email"]
                    let class_year = user["class_year"]
                    let posts = user["posts"]
                    let gender = user["gender"]
                    let avatar = user["avatar"]
                    let newUser = User(username: username! as! String,
                                       password: password! as! String,
                                       email:email! as! String ,
                                       class_year: class_year! as! String,
                                       posts : posts as! [String],
                                       gender: gender! as! String,
                                       avatar: avatar! as! String )
                    self.Users.append(newUser)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addUser(id: String, user: User) {
        // define array of key/value pairs to store for this person.
        let userRecord = [
            "username": user.username,
            "password": user.password,
            "email": user.email,
            "class_year": user.class_year,
            "posts": user.posts,
            "gender" : user.gender,
            "avatar" : user.avatar,
            ] as [String : Any]
        
        // Save to Firebase.
    self.ref.child("users").child(id).setValue(userRecord)
        
        // Also save to our internal array, to stay in sync with what's in Firebase.
        Users.append(user)
    }
    
    // **********************************************************************
    // *******************                               ********************
    // ******************* load comment and add comment  ********************
    // *******************                               ********************
    // **********************************************************************
    
    func getPost(index: Int) -> Post{
        return Posts[index]
    }
    
    func loadPost(){
        Posts = [Post]()
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get the top-level dictionary.
            let value = snapshot.value as? NSDictionary
            
            if let posts = value {
                // Iterate over the person objects and store in our internal people array.
                for p in posts {
                    let post_id = p.key as! String
                    let post = p.value as! [String:Any]
                    let post_user = post["post_user"]
                    let post_image = post["post_image"]
                    let post_location = post["post_location"]
                    let post_text = post["post_text"]
                    let post_time = post["post_time"]
                    let post_like = post["post_like"]
                    let post_comment = post["post_comment"]
        
                    let newPost = Post(uid:post_user as! String,
                                       text:post_text as! String,
                                       image: post_image as! String,
                                       location: post_location as! String,
                                       time: post_time as! String,
                                       like : post_like as! [String],
                                       comments: post_comment as! [String])
                    self.Posts.append(newPost)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func addPost(post: Post) {
        // define array of key/value pairs to store for this person.
        let postRecord:[String:Any] = [
            "post_user": post.uid,
            "post_image": post.image,
            "post_location": post.location,
            "post_text": post.text,
            "post_time": post.time,
            "post_like": post.like,
            "post_comment" : post.comments
            ]
        // Save to Firebase.
        let key = self.ref.child("posts").childByAutoId().key
        
        self.ref.child("posts").child(key).setValue(postRecord)
        // Update the user's post list.
        let userID = Auth.auth().currentUser?.uid
        ref.child("users").child(userID!).child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSArray
            var post_list = value as! [String]
            post_list.append(key)
            self.ref.child("users").child(userID!).updateChildValues(["posts" : post_list])
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
        // Also save to our internal array, to stay in sync with what's in Firebase.
        Posts.append(post)
    }
    
    // **********************************************************************
    // *******************                               ********************
    // ******************* load comment and add comment  ********************
    // *******************                               ********************
    // **********************************************************************
    
    func getComment(index:Int) ->Comment{
        return Comments[index]
    }
    func loadComment(){
        // Start with an empty array of User objects.
        Comments = [Comment]()
        // Fetch the data from Firebase and store it in our internal Comments array.
        // This is a one-time listener.
        ref.child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get the top-level dictionary.
            let value = snapshot.value as? NSDictionary
            if let comments = value{
                // Iterate over the person objects and store in our internal people array.
                for c in comments {
                    let comment_id = c.key as! String
                    let comment = c.value as! [String:Any]
                    let comment_uid = comment["comment_uid"]
                    let comment_postid = comment["postid"]
                    let comment_time = comment["comment_time"]
                    let comment_by = comment["comment_by"]
                    let comment_text = comment["comment_text"]
                    
                    let newComment = Comment(uid: comment_uid as! String,
                                             post_id: comment_postid as! String,
                                             text: comment_text as! String,
                                             comment_by: comment_by! as! [String],
                                             time: comment_text! as! String)
                    self.Comments.append(newComment)
                }
            }
            
        }) {
            (error) in
            print(error.localizedDescription)
        }
    }
    func addComment(comment:Comment){
        // define array of key/value pairs to store for this comment.
        let commentRecord = [
            "comment_time": comment.time,
            "comment_by": comment.comment_by,
            "comment_text": comment.text
            ] as [String : Any]
        
        //        save to Firebase
        self.ref.child("comments").childByAutoId().setValue(commentRecord)
        //        also save to our internal array, to stay in sync with what's in Firebase
        Comments.append(comment)
        
    }
}

