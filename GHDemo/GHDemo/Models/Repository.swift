//
//  Repository.swift
//  GHDemo
//
//  Created by user on 13/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation


struct Repository: Codable {
    
    var id: Int
    var full_name: String
    var description: String?
    var name: String
    var html_url: String?
    var forks_count: Int?
    var watchers_count: Int?
    var subscribers_count: Int?
    var `private` : Bool?
    var languages_url: String?
    var owner: User?
    var license: License?
}
