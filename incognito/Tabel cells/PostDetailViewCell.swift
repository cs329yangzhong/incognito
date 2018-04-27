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
    var post1: Post?
    var postid: String?
    var postperson: String?
    
    @IBOutlet weak var AnimateImg: UIImageView!
    var Storeimg :[UIImage]?

    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var Username: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var textcontent: UILabel!
    @IBOutlet weak var postTime: UILabel!
    @IBOutlet weak var morePictureIndicator: UILabel!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    
    // Like button handler.
    @IBOutlet weak var LikeButton: UIButton!
    @IBAction func DidPressLike(_ sender: Any) {
        
        print("Press the like button")
        
        // Check the status of the user.
        let status = DataStore.shared.DidpressLike(postid: postid!, Likeperson: postperson!)

        // the user canceled like.
        var likeNumber = Int(likeCount.text!)!
        if LikeButton.isSelected == true || status == 0{
            LikeButton.setImage(UIImage(named: "like_icon"), for: .normal)
            LikeButton.isSelected = false
            likeNumber -= 1
            likeCount.text = String(likeNumber)
            
            
        } else if LikeButton.isSelected == false && status == 1 {
            LikeButton.setImage(UIImage(named: "like"), for: .normal)
            LikeButton.isSelected = true
            likeNumber += 1
            likeCount.text = String(likeNumber)
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
