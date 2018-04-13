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
//    download images.
    func downloadImges() {
        for i in post1!.image {
        if (i != "none") {
            let url = URL(string: i)!
            var CurrentImg = UIImageView.init(image: UIImage(named:"icon2"))
            CurrentImg.kf.setImage(with: url)
            Storeimg?.append(CurrentImg.image!)
        }
        }
    }
    
    func animateImg() {
        AnimateImg.animationImages = Storeimg
        AnimateImg.animationDuration = 0.04
        AnimateImg.animationRepeatCount = 3
        AnimateImg.startAnimating()
    }
    
    
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
            LikeButton.setImage(UIImage(named: "like_icon"), for: .highlighted)
            LikeButton.setImage(UIImage(named: "like_icon"), for: .normal)
            
        } else if status == 1 {
            LikeButton.setImage(UIImage(named: "like"), for: .highlighted)
            LikeButton.setImage(UIImage(named: "like"), for: .normal)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
