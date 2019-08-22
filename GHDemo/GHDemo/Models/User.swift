//
//  User.swift
//  GHDemo
//
//  Created by user on 13/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation


struct User: Codable {
    
    var avatar_url: String?
    var name: String?
    var login: String?
    var followers: Int?
    var following: Int?
    var type: String?
    var html_url: String?
    var bio: String?
    var blog: String?
    var company: String?
    var location: String?
}
