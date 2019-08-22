//
//  BaseNavigationController.swift
//  GHDemo
//
//  Created by user on 13/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

/*Root Navigator initializes UIWindow root view controller*/

final class RootNavigator {
    
    /*shared instance to set or switch root view controller globally*/
    static var sharedInstance: RootNavigator = RootNavigator()
    
    /*switch root view controller*/
    /*switch b/w login and home screen*/
    func setRoot() {
        let isLoggedIn = UserDefaults.standard.isLoggedIn
        isLoggedIn ? switchToHome() : switchToLogin()
    }
    
    // swicth to login view controller
    func switchToLogin() {
        let controller = LoginViewController.initiate(with: .Login)
        setWindowRootController(controller)
    }
    
    // swicth to home view controller
    func switchToHome() {
        let controller = Storyboard.Home.initialViewController()
        setWindowRootController(controller)
    }
    
    /*set root view controller with CATransition*/
    func setWindowRootController(_ controller: UIViewController) {
        
        // CATransition for smooth switching b/w controllers
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.subtype = nil
        transition.duration =  0.20
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName(rawValue: CAMediaTimingFunctionName.linear.rawValue))
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.window = delegate.window ?? UIWindow()
        delegate.window?.makeKeyAndVisible()
        delegate.window?.layer.add(transition, forKey: kCATransition)
        delegate.window?.rootViewController = controller
    }
}
