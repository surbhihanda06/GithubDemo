//
//  Storyboard.swift
//  GHDemo
//
//  Created by user on 22/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import UIKit

/*Storyboard
- helps in easy initilization of ViewControllers
- always name the case with same name given to storyboard file
*/

enum Storyboard: String {
    
    case Login
    case Home
    
    func initiate<T: UIViewController>(_ controller: T.Type) -> T {
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "\(controller)")
        return controller as! T
    }
    
    func initialViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: rawValue, bundle: nil)
        return storyboard.instantiateInitialViewController()!
    }
 }

extension UIViewController {
    class func initiate(with storyboard: Storyboard) -> Self {
        return storyboard.initiate(self)
    }
}

