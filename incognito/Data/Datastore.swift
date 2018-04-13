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
    
    // Making the init method private means only this class
    // can instantiate an object of this type.
    private init() {
        // Get a database reference.
        // Needed before we can read/write to/from the firebase database.
        ref = Database.database().reference()
    }
    
    func getUser(index: Int) -> User {
        return Users[index]
    }
    func countPost() -> Int {
        return Posts.count
    }
    
    func reloadPost(){
        loadPost()
    }
    
    func reloadComment() {
        loadComment()
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
    
    // Add a new user.
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
        
                    let newPost = Post(id: post_id,
                                       uid:post_user as! String,
                                       text:post_text as! String,
                                       image: post_image as! [String],
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
    var PostImage = ["None"]
    var current_key = "None"
    
    // *************************** Add Post. ***********************************
    func addPost(post: Post, ImgList: [UIImage]) {
        
        // Create a new key in firease that represent this new post's id.
        let key = self.ref.child("posts").childByAutoId().key
        
        // save the key in dataStore wide.
        self.current_key = key
        
        // Get current user's id.
        let userID = Auth.auth().currentUser?.uid
        let postRecord:[String:Any] = [
            "id": key,
            "post_user": post.uid,
            "post_image": post.image,
            "post_location": post.location,
            "post_text": post.text,
            "post_time": post.time,
            "post_like": post.like,
            "post_comment" : post.comments
        ]
        
        // Upload the post object to firebase.
        self.ref.child("posts").child(key).setValue(postRecord)
        
        // Update the user's post list.
        ref.child("users").child(userID!).child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSArray
            var post_list = value as! [String]
            post_list.append(key)
            self.ref.child("users").child(userID!).updateChildValues(["posts" : post_list])
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        // Save image url to post_image in Firebase.
        var Finish:Int = ImgList.count - 1
        
        while (Finish >= 0){
            var data = NSData()
            data = UIImageJPEGRepresentation(ImgList[Finish], 0.8)! as NSData
            let filePath = "\(Auth.auth().currentUser!.uid)/\(key)/\(Finish)"
            Finish = Finish - 1
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            DataStore.storage.reference().child(filePath).putData(data as Data, metadata: metaData){(metaData,error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }else{
                    
                    //store downloadURL
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    self.ref.child("posts").child(self.current_key).observeSingleEvent(of: .value, with: { (snapshot) in
                        // Get user value
                        let Post = snapshot.value as? NSDictionary
                        let IMages = Post?["post_image"] as? [String]
                        var Postimage = IMages as! [String]
                        Postimage.append(downloadURL)
                        post.image.append(downloadURL)
                    self.ref.child("posts").child(self.current_key).updateChildValues(["post_image" : Postimage])
                    }){ (error) in
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
        // Also save to our internal array, to stay in sync with what's in Firebase.
        Posts.append(post)
    }
   
    // **********************************************************************
    // *******************                               ********************
    // ******************* load comment and add comment  ********************
    // *******************                               ********************
    // **********************************************************************
    
    var cur_commentkey = "None"
    func getComment(id: String) -> Any {
        for i in Comments {
            if (i.id == id) {
                return i
            }
        }
        return 0
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
                    let comment_postid = comment["comment_postid"]
                    let comment_time = comment["comment_time"]
                    let comment_by = comment["comment_by"]
                    let comment_text = comment["comment_text"]
                    
                    // Create a comment object.
                    let newComment = Comment(id: comment_id,
                                             post_id: comment_postid as! String,
                                             text: comment_text as! String,
                                             comment_by: comment_by! as! String,
                                             time: comment_text! as! String)
                    
                    self.Comments.append(newComment)
                }
            }
        })
        {
            (error) in
            print(error.localizedDescription)
        }
    }
    
    func addComment(comment:Comment){
        
        // define array of key/value pairs to store for this comment.
        let key = self.ref.child("comments").childByAutoId().key
        let postid = comment.post_id
        
        // define array of key/value pairs to store for this comment.
        let commentRecord = [
            "comment_id": key,
            "comment_postid": comment.post_id,
            "comment_time": comment.time,
            "comment_by": comment.comment_by,
            "comment_text": comment.text
            ] as [String : Any]
        
        // save to Firebase
        self.ref.child("comments").child(key).setValue(commentRecord)
        
        // also save to our internal array, to stay in sync with what's in Firebase
        Comments.append(comment)
        
        // Update the user's post's comments list.
        ref.child("posts").child(postid).child("post_comment").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSArray
            var comments = value as! [String]
            comments.append(key)
            self.ref.child("posts").child(postid).updateChildValues(["post_comment" : comments])
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    //  Show user's avatar.
    func ShowAvatarName(uid: String, Avatar: UIImageView, Name: UILabel){
        let usersRef = Database.database().reference().child("users").child(uid)
        
        // observe the current user once and store all the basic information.
        usersRef.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return}
            let userInfo = snapshot.value as! NSDictionary
            let username = userInfo["username"] as! String
            Name.text = username
            let profileUrl = userInfo["avatar"] as! String

            // If the user hasn't set up avatar, use the default one.
            if (profileUrl == "None"){
                Avatar.image = UIImage(named: "icon2")
                return
            }
            
            // Download the avatar from firebase and update the poster's avatar.
            let storageRef = Storage.storage().reference(forURL: profileUrl)
            storageRef.downloadURL(completion: { (url, error) in
                if let error = error{
                    print(error.localizedDescription)
                    return
                }else{
                    let data = NSData(contentsOf: url!)
                    let image = UIImage(data: data! as Data)
                    Avatar.image = image
                }
            })
        })
    }
    
    
    // Update user's gender and class
    func updateGenderClassName (gender: String, classYear: String, userName: String) {
        let userID = Auth.auth().currentUser?.uid
        self.ref.child("users").child(userID!).updateChildValues(["gender" : gender])
        self.ref.child("users").child(userID!).updateChildValues(["class_year" : classYear])
        self.ref.child("users").child(userID!).updateChildValues(["username" : userName])
        print ("Successfully update user's name, gender and class")
    }
    
    // Like function.
    func DidpressLike( postid: String, Likeperson: String) -> Int{

        // 0 means cancel liked. 1 means didlike.
        var status = 0
        let currentPost = self.ref.child("posts").child(postid)
        
        // observe the current post once and store all the basic information.
        currentPost.observeSingleEvent(of: .value, with: { snapshot in
            if !snapshot.exists() { return}
            let PostInform = snapshot.value as! NSDictionary
            let Likelist =  PostInform["post_like"] as! [String]
            var NewLikelist = Likelist
            
            // If the user has liked the post, Then he chose to dislike.
            if Likelist.contains(Likeperson){
                NewLikelist = NewLikelist.filter{$0 != Likeperson}
                status = 0
            print("User dislikes the post")
                
            // The user has not liked the post. Click to like.
            } else {
                NewLikelist.append(Likeperson)
                status = 1
                print(" User Liked the post")
            }
            
            self.ref.child("posts").child(postid).updateChildValues(["post_like" : NewLikelist])
        }){ (error) in
            print(error.localizedDescription)
        }
        return status
    }
    
    // Fetch Comment details。
    func GetComment(Avatar: UIImageView, Postid: String, index: Int,
                    CurrentPost: Post, Content: UILabel, time: UILabel ) {
        
        let commentID = CurrentPost.comments[index+1]
        let Comment1 = getComment(id: commentID) as! Comment
            let commentUser = Comment1.comment_by
        
            Content.text = Comment1.text
            time.text = Comment1.time
        
        // Fetch Comment user's avatar.
        let usersRef = self.ref.child("users").child(commentUser)
        
        // observe the current user once and store all the basic information.
        usersRef.observeSingleEvent(of: .value, with: {
            snapshot in
            if !snapshot.exists() { return}
            let userInfo = snapshot.value as! NSDictionary
            
            // Using KingFisher to download and save avatar.
            let UserUrl = userInfo["avatar"] as! String
            let url = URL(string: (UserUrl))
            Avatar.kf.setImage(with: url)

        })
    }
}
