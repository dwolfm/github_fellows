//
//  Repository.swift
//  github_fellows
//
//  Created by nacnud on 1/24/15.
//  Copyright (c) 2015 nanud. All rights reserved.
//

import Foundation

struct Repository {
    let name: String
    let url: String
    
    init(jsonDictionary: [String: AnyObject]) {
        self.name = jsonDictionary["name"] as String
        self.url = jsonDictionary["html_url"] as String
    }
}