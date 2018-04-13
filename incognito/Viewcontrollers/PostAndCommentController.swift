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

class PostAndCommentController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var UserAvatar: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var CommentNumber: UILabel!
    @IBOutlet weak var PostNumber: UILabel!
    
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
        self.PostNumber.text = String((userInfo["posts"] as! [String]).count)
        
        // TODO get the Comment.
        
    })
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ObserveUser()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
