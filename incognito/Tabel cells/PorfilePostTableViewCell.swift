//
//  PorfilePostTableViewCell.swift
//  incognito
//
//  Created by 邢楷涓 on 4/15/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import UIKit

class PorfilePostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTimeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
