//
//  EndPoint.swift
//  GHDemo
//
//  Created by user on 22/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation


enum API: String {
    
    private static let baseURL = "https://api.github.com/"
    
    case user
    case authorizations
    case repos
    case user_starred = "user/starred"
    case user_repos = "user/repos"
    
    var endPoint: String {
        return API.baseURL + rawValue
    }
}
