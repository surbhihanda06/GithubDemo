//
//  AppDelegate.swift
//  GHDemo
//
//  Created by user on 09/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /*set root view controller of UIWindow*/
        RootNavigator.sharedInstance.setRoot()
        
        /*set default appearance properties*/
        UINavigationBar.appearance().tintColor = .black
        UITabBar.appearance().tintColor = .black
        UISearchBar.appearance().tintColor = .black
        
        return true
    }
}

