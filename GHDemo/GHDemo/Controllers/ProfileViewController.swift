//
//  ProfileViewController.swift
//  GHDemo
//
//  Created by user on 14/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, ActivityIndicatorViewable {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblFollowersCount: UILabel!
    @IBOutlet weak var lblFollowingCount: UILabel!
    @IBOutlet weak var lblBoi: UILabel!
    @IBOutlet weak var btnBlog: UIButton!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    var indicatorView: ActivityIndicatorView = ActivityIndicatorView()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupIndicator()
        profileWebService()
    }
    
    //MARK: Profile Web Service 
    private func profileWebService() {
        let rest = RestManager<User>()
        showloader(color: UIColor.groupTableViewBackground)
        rest.makeRequest(toURL: API.user.endPoint, withHttpMethod: .get) { [weak self] (result) in
            self?.hideloader()
            switch result {
            case .success(let user):
                self?.updateInterface(user: user)
            case .failure(let error):
                self?.view.makeToast(error.description)
            }
        }
    }
    
    // load user data
    private func updateInterface(user: User) {
        lblName.text = user.name
        lblUsername.text = "@" + (user.login ?? "")
        lblFollowersCount.text = "\(user.followers ?? 0)"
        lblFollowingCount.text = "\(user.following ?? 0)"
        imageView.downloaded(from: user.avatar_url, contentMode: .scaleAspectFill)
        lblBoi.text = user.bio
        lblLocation.text = user.location
        lblType.text = user.type
        btnBlog.createLink(user.blog ?? "")
        stackView.hideEmptyLabels()
        stackView.hideEmptyButtons()
    }
    
    //MARK: Blog Action
    @IBAction func btnBlog(_ sender: UIButton) {
        let controller = WebViewController.initiate(with: .Home)
        controller.urlString = sender.titleLabel?.attributedText?.string
        controller.title = "Blog"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    //MARK: Logout Action
    @IBAction func logoutUser(_ sender: UIButton) {
        
        let actionSheet = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        
        let logout = UIAlertAction.init(title: "Logout", style: .destructive) { (_) in
            UserDefaults.standard.clearAll()
            RootNavigator.sharedInstance.switchToLogin()
        }
        
        let cancel = UIAlertAction.init(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(logout)
        actionSheet.addAction(cancel)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
}
