//
//  RepositoriesViewController.swift
//  GHDemo
//
//  Created by user on 13/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class StarredViewController: UIViewController, ActivityIndicatorViewable {
    
    @IBOutlet weak var repoTableView: RepositoriesTableView!
    var indicatorView: ActivityIndicatorView = ActivityIndicatorView()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupIndicator()
        showloader(color: UIColor.groupTableViewBackground)
        
        repoTableView.load(with: API.user_starred.endPoint)
        repoTableView.repodelegate = self
    }
    
    @IBAction func btnSearch(_ sender: UIButton) {
        let controller = SearchViewController.initiate(with: .Home)
        controller.url = API.user_starred.endPoint
        self.navigationController?.pushViewController(controller, animated: false)
    }
}

//MARK: RepoTableViewDelegate
extension StarredViewController: RepoTableViewDelegate {
    
    func didEndLoadingRepositories() {
        hideloader()
    }
    
    func didSelect(_ repository: Repository) {
        let controller = DetailViewController.initiate(with: .Home)
        controller.repo_name = repository.full_name
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func didFailedWithError(_ error: WebError) {
       self.view.makeToast(error.description)
    }
}
