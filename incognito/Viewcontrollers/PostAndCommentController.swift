//
//  PostAndCommentController.swift
//  incognito
//
//  Created by yang zhong on 4/13/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit
import Kingfisher
import Firebase

class PostAndCommentController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // Todo: Update the refresher.
var refresher: UIRefreshControl!
    
@IBOutlet weak var UserAvatar: UIImageView!
@IBOutlet weak var Username: UILabel!
@IBOutlet weak var CommentNumber: UILabel!
@IBOutlet weak var PostNumber: UILabel!
@IBOutlet weak var segControlTwoOptions: UISegmentedControl!

@IBOutlet weak var myTableView: UITableView!

var currentSegOption = 0
var currentUserPosts = [Post]()
var commentLists = [Comment]()
var deletePlanetIndexPath: NSIndexPath? = nil


// Keep observing Current user's details.
func ObserveUser() {
    let usersRef = Database.database().reference().child("users").child(Auth.auth().currentUser!.uid)

// observe the current user once and store all the basic information.
usersRef.observeSingleEvent(of: .value, with: {
        snapshot in
    
    if !snapshot.exists() { return}
    let userInfo = snapshot.value as! NSDictionary
    
    
    // Using KingFisher to download and save avatar.
    let UserUrl = userInfo["avatar"] as! String
    let url = URL(string: (UserUrl))
    self.UserAvatar.kf.setImage(with: url)
    
    self.Username.text = (userInfo["username"] as! String)
    self.PostNumber.text = String((userInfo["posts"] as! [String]).count - 1)
    
//        get Posts list by post id
    var userPostsList = [String] ()
    userPostsList = userInfo["posts"] as! [String]
//        print(self.userPostsList)
    self.currentUserPosts = DataStore.shared.getPostByID(idArray: userPostsList)
    print(userPostsList.count)
//        get Comments List
    
    self.commentLists = DataStore.shared.getCommentByID(UserPostList: self.currentUserPosts)
    
//        get posts images counts
    var img_count = 0
    for p in self.currentUserPosts{
        
        // Decease by 1 since the imagelist's length was default to be 1.
        img_count += (p.image.count - 1)
    }
    
    self.CommentNumber.text = String(img_count)
    
})
}
override func viewDidLoad() {
    super.viewDidLoad()
    currentSegOption = 0
    myTableView.reloadData()
    ObserveUser()
    // Do any additional setup after loading the view.
    
    // add refresher.
    refresher = UIRefreshControl()
    refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
    refresher.addTarget(self, action: #selector(PostAndCommentController.populate),
                        for: UIControlEvents.valueChanged)
    myTableView.addSubview(refresher)
}
    
    @objc func populate(){
        ObserveUser()
        myTableView.reloadData()
        refresher.endRefreshing()
    }

@IBAction func segControlAction(_ sender: Any) {
    self.currentSegOption = self.segControlTwoOptions.selectedSegmentIndex
    
    myTableView.reloadData()
    
}
    
func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 1
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
{
    if (self.currentSegOption == 0){
        return 365.0;//Choose your custom row height
    }else{
        return 90.5
    }
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    var CountofRows = 0
    if self.currentSegOption == 0{
//            return self.currentUserPosts.count
        CountofRows = self.currentUserPosts.count
        
    }
    else if self.currentSegOption == 1{
//            return self.commentLists.count
        CountofRows = self.commentLists.count
    }
    
    return CountofRows
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if self.currentSegOption == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PorfilePostTableViewCell
        
//            cell.postImage.image = self.currentUserPosts[index]
        cell.postTimeLabel.text = self.currentUserPosts[indexPath.item].time
        cell.UserId = self.currentUserPosts[indexPath.item].uid
        cell.Postid = self.currentUserPosts[indexPath.item].id
        cell.postText.text = self.currentUserPosts[indexPath.item].text
        if self.currentUserPosts[indexPath.item].image.count >= 2 {
            let url = URL(string: (self.currentUserPosts[indexPath.item].image)[1])
            cell.postImage.kf.setImage(with: url)
        }
        return cell
        
    } else {
        let cell = tableView.dequeueReusableCell(withIdentifier: "profileCommentCell", for: indexPath) as! ProfileCommentTableViewCell
        let comment = commentLists[indexPath.item]
        
        print("the comment time is \(comment.time)")
        
        cell.CommentTime.text = comment.time
        cell.CommentContent.text = comment.text
        print("comment by \(comment.comment_by)")
        
        // Download userAvatar.
        let usersRef = Database.database().reference().child("users").child(comment.comment_by)
        var cellURL: URL?
        
        // observe the current user once and store all the basic information.
        usersRef.observeSingleEvent(of: .value, with: {
            snapshot in

            if !snapshot.exists() { return }
            let userInfo = snapshot.value as! NSDictionary

            // Using KingFisher to download and save avatar.
            let UserUrl = userInfo["avatar"] as! String


            if (UserUrl == "None"){
                cell.UserAvatar.image = UIImage(named: "icon2")
                
            }else{
                
            cellURL = URL(string: (UserUrl))
            print("UserUrl is \(cellURL!)")
            cell.UserAvatar.kf.setImage(with: cellURL!, placeholder: UIImage(named: "icon2"))
            }
            })
        
        return cell
        }
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
    if self.currentSegOption == 0{
        if editingStyle == .delete {
            _ = self.currentUserPosts[indexPath.item].uid
            _ = self.currentUserPosts[indexPath.item].id
            deletePlanetIndexPath = indexPath as NSIndexPath
            confirmDelete()
            }
    }
}
    
    func confirmDelete() {
    let alert = UIAlertController(title: "Delete Post", message: "Are you sure you want to permanently delete this post?", preferredStyle: .actionSheet)
    
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler:handleDeletePlanet)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: cancelDeletePlanet)
    
    alert.addAction(DeleteAction)
    alert.addAction(CancelAction)
    
    // Support display in iPad
    alert.popoverPresentationController?.sourceView = self.view
//    alert.popoverPresentationController?.sourceRect = CGRectMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0, 1.0, 1.0)
    
    self.present(alert, animated: true, completion: nil)
}
    
    func handleDeletePlanet(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deletePlanetIndexPath {
            
            let deleteUserid = self.currentUserPosts[indexPath.item].uid
            let deletePostid = self.currentUserPosts[indexPath.item].id
            print(deletePostid)
            print(deleteUserid)
            DataStore.shared.deletePost(postid: deletePostid, UserId: deleteUserid)
            ObserveUser()
            // Note that indexPath is wrapped in an array:  [indexPath]
            deletePlanetIndexPath = nil
            
            myTableView.reloadData()
        }
    }
    func cancelDeletePlanet(alertAction: UIAlertAction!) {
        deletePlanetIndexPath = nil
    }
    
    
/*
// MARK: - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
}
*/

}
