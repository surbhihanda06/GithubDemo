//
//  Authorization.swift
//  GHDemo
//
//  Created by user on 24/07/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

enum Authorization {
    
    case basic(username: String, secret: String)
    case bearer(token: String)
    
    func setHeader() {
        UserDefaults.standard.setAuthorization(header())
    }
}

extension Authorization {
    fileprivate func header() -> String {
        switch self {
        case .basic(let username, let secret):
            let initial = username + ":" + secret
            let utf8str = initial.data(using: String.Encoding.utf8)
            let basic_auth_token = utf8str?.base64EncodedString(options: [])
            return "Basic " + (basic_auth_token ?? "")
        case .bearer(let token):
            return "Bearer" + " " + token
        }
    }
}
