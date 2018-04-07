//
//  Post.swift
//  incognito
//
//  Created by yang zhong on 3/3/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import Foundation
class Post {
    var id: String
    var uid: String
    var text: String
    var image = [String]()
    var location: String
    var time: String
    var like = [String]()
    var comments = [String]()
    
    init(id: String,  uid: String, text: String, image: [String],location: String,  time: String,  like: [String], comments: [String]) {
        self.id = id
        self.uid = uid
        self.text = text
        self.image = image
        self.location = location
        self.like = like
        self.comments = comments
        self.time = time
    }
}
