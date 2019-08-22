//
//  RepoTableViewDelegate.swift
//  GHDemo
//
//  Created by user on 22/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation

// Repository Table View Delegate Method
protocol RepoTableViewDelegate {
    
    /*called when tabelview end loading data*/
    func didEndLoadingRepositories()
    
    /*called when tableview cell selected*/
    func didSelect(_ repository: Repository)
    
    /*called if error occurs*/
    func didFailedWithError(_ error: WebError)
}
