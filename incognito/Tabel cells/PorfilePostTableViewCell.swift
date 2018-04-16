//
//  PorfilePostTableViewCell.swift
//  incognito
//
//  Created by 邢楷涓 on 4/15/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit

class PorfilePostTableViewCell: UITableViewCell, UIAlertViewDelegate {

    var Postid: String?
    var UserId: String?
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var postText: UILabel!
    
    @IBAction func DeletePost(_ sender: Any) {
        
//        let alert = UIAlertController(title: "Alert",
//                                      message: "Are you sure to delete this post? ",
//                                      preferredStyle: UIAlertControllerStyle.alert)
//
//        alert.addAction(UIAlertAction(title: "Yes", style:
//            UIAlertActionStyle.default, handler: Delete))
//        alert.addAction(UIAlertAction(title: "Cancel", style:
//            UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        DataStore.shared.deletePost(postid: Postid!, UserId: UserId!)
        print("Successfully delete the post")
    }
    func Delete(_sender: UIAlertAction){
        DataStore.shared.deletePost(postid: Postid!, UserId: UserId!)
        print("Successfully delete the post")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
