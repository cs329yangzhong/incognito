//
//  ProfileCommentTableViewCell.swift
//  incognito
//
//  Created by 邢楷涓 on 4/25/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit

class ProfileCommentTableViewCell: UITableViewCell {

    @IBOutlet weak var UserAvatar: UIImageView!
    @IBOutlet weak var CommentContent: UILabel!
    @IBOutlet weak var CommentTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
