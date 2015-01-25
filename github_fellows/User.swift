//
//  User.swift
//  github_fellows
//
//  Created by nacnud on 1/24/15.
//  Copyright (c) 2015 nanud. All rights reserved.
//

import UIKit

struct User {
    let name : String
    let avatarURL : String
    var avatarImage: UIImage?
    
    init(jsonDictionary : [String: AnyObject]){
        self.name = jsonDictionary["login"] as String
        self.avatarURL = jsonDictionary["avatar_url"] as String
    }
}