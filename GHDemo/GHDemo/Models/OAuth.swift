//
//  0Auth.swift
//  GHDemo
//
//  Created by user on 19/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

class OAuth: Codable {
    
    let token: String
    let hashed_token: String
    let token_last_eight: String
    let url: String
    let id : Double
}
