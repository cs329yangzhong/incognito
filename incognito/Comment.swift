//
//  Comment.swift
//  incognito
//
//  Created by yang zhong on 3/3/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import Foundation
class Comment {
    
    var text: String
    var comment_by: String
    var time: String
    
    init(text: String, comment_by: String, time: String) {
        self.text = text
        self.comment_by = comment_by
        self.time = time
    }
}
