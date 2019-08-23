//
//  UserDefaults.swift
//  GHDemo
//
//  Created by user on 22/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

/*default methods to save app data in preferences*/
extension UserDefaults {
    
    // return default login status
    var isLoggedIn: Bool {
        return bool(forKey: "login")
    }
    
    // returns default authorization header
    var authorization_type: String? {
        return string(forKey: "authorization")
    }
    
    // set default login status
    func setLoginStatus(_ bool: Bool) {
        set(bool, forKey: "login")
    }
    
    // set default authorization header
    func setAuthorization(_ authorization: String) {
        set(authorization, forKey: "authorization")
    }
    
    // clear all default stored values 
    func clearAll() {
        let domain = Bundle.main.bundleIdentifier!
        removePersistentDomain(forName: domain)
        synchronize()
    }
}
