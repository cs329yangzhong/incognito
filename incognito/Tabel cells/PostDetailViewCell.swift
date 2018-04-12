//
//  PostDetailViewCell.swift
//  incognito
//
//  Created by yang zhong on 3/30/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit

// This is the cell in Discover page.
class PostDetailViewCell: UITableViewCell, UIScrollViewDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var postid: String?
    var postperson: String?
    
    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var textcontent: UILabel!
    
    // Like button handler.
    @IBOutlet weak var LikeButton: UIButton!
    @IBAction func DidPressLike(_ sender: Any) {
        print("Press the like button")
        
        // Check the status of the user.
        let status = DataStore.shared.DidpressLike(postid: postid!, Likeperson: postperson!)
        
        // the user canceled like.
        if status == 0 {
            LikeButton.setImage(UIImage.init(named: "like_icon"), for: .normal)
            print("user Unlike the post")
        } else {
            LikeButton.setImage(UIImage.init(named: "like"), for: .normal)
            print("User like the post")
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
