//
//  RepoDetailViewController.swift
//  GHDemo
//
//  Created by user on 19/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, ActivityIndicatorViewable {
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblWatch: UILabel!
    @IBOutlet weak var lblStar: UILabel!
    @IBOutlet weak var lblFork: UILabel!
    @IBOutlet weak var lblLicense: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var imgOwner: UIImageView!
    @IBOutlet weak var imgType: UIImageView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblUserType: UILabel!
    @IBOutlet weak var btnLink: UIButton!
    @IBOutlet weak var lblLanguages: UILabel!

    var indicatorView: ActivityIndicatorView = ActivityIndicatorView()
    var repo_name: String!
    var repo: Repository!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupIndicator()
        detailWebService()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: Repository Detail Web Service
    func detailWebService() {
        
        self.showloader(color: UIColor.groupTableViewBackground)
        let rest = RestManager<Repository>()
        rest.makeRequest(toURL: API.repos.endPoint + "/\(repo_name!)", withHttpMethod: .get) { [weak self] (result) in
            self?.hideloader()
            switch result {
            case .success(let repo):
                self?.repo = repo
                self?.languagesWebService()
                self?.updateInterface(repo)
            case .failure(let error):
                self?.lblError.text = error.description
                self?.scrollView.isHidden = true
            }
        }
    }
    
    // languages web service
    private func languagesWebService() {
        if let url = repo?.languages_url {
            let rest = RestManager<Response>()
            rest.makeRequest(toURL: url, withHttpMethod: .get) { [weak self] (result) in
                self?.lblLanguages.text = rest.response.keys.joined(separator: " , ")
            }
        }
    }
    
    // update interface
    private func updateInterface(_ repo: Repository) {
        title = repo.name
        lblName.text = repo.full_name
        lblDescription.text = repo.description
        lblWatch.text = "\(repo.subscribers_count ?? 0)"
        lblStar.text = "\(repo.watchers_count ?? 0)"
        lblFork.text = "\(repo.forks_count ?? 0)"
        lblLicense.text = repo.license?.name
        lblUsername.text = "@" + (repo.owner?.login ?? "")
        lblUserType.text = repo.owner?.type
        lblType.text = repo.private ?? false ? "Private" : "Public"
        imgType.image = repo.private ?? false ?  #imageLiteral(resourceName: "lock") : #imageLiteral(resourceName: "unlock")
        btnLink.createLink(repo.html_url ?? "")
        imgOwner.downloaded(from: repo.owner?.avatar_url, contentMode: .scaleAspectFill)
    }
    
    // profile button action (view profile)
    @IBAction func btnViewProfile(_ sender: UIBarButtonItem) {
        let controller = WebViewController.initiate(with: .Home)
        controller.urlString = repo?.owner?.html_url
        controller.title = "Profile"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // repository button action (go to repository)
    @IBAction func btnGoToRepository(_ sender: UIBarButtonItem) {
        
        if repo?.private ?? false {
            self.view.makeToast("Github does not allow to access private repository")
        }
        else {
            let controller = WebViewController.initiate(with: .Home)
            controller.urlString = repo?.html_url
            controller.title = "Repository"
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    // back button action
    @IBAction func btnBack(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
