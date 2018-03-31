//
//  User.swift
//  incognito
//
//  Created by yang zhong on 3/3/18.
//  Copyright © 2018 yang zhong. All rights reserved.
//

import Foundation
class User {
    
    var username: String
    var password: String
    var email: String
    var class_year: String
    var posts = [String]()
    var gender: String
    var avatar: String
    
    init(username: String, password: String, email: String,class_year: String,posts :[String], gender: String,avatar: String) {
        self.username = username
        self.password = password
        self.email = email
        self.class_year = class_year
        self.posts = posts
        self.gender = gender
        self.avatar = avatar
    }
}
