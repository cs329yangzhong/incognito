//
//  CommentsCell.swift
//  incognito
//
//  Created by yang zhong on 4/11/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit

class CommentsCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var CommentTime: UILabel!
    @IBOutlet weak var CommentContent: UILabel!
    @IBOutlet weak var UserAvatar: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
