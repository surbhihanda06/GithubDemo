//
//  WebError.swift
//  GHDemo
//
//  Created by user on 13/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

public enum WebError: Error {
    
    case noInternetConnection
    case invalidRequest(String)
    case parse
    case unauthorized
    case other(String)
}

extension WebError {
    
    var description: String {
        switch self {
        case .noInternetConnection:
            return "No internet connectivity"
        case .invalidRequest(let url):
            return "URLRequest is not valid: \(url)"
        case .unauthorized:
            return "Invalid credentials. Please check your username or password"
        case .parse:
            return "Unable to parse json"
        case .other(let error):
            return error
        }
    }
}
