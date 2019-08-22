//
//  ViewController.swift
//  GHDemo
//
//  Created by user on 09/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Eureka

//Login Form
class LoginViewController: FormViewController, ActivityIndicatorViewable {
    
    @IBOutlet weak var btnLogin: UIButton!
    var indicatorView: ActivityIndicatorView = ActivityIndicatorView()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        setupIndicator()
        buildForm()
    }
    
    //MARK: Eureka form builder
    private func buildForm() {
        
        form +++ Section()
            
            <<< TextRow("username") {
                $0.title = "Username"
                $0.add(rule: RuleRequired())
                $0.validationOptions = .validatesOnChange
                }.cellUpdate({ (cell, row) in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
                })
            
            <<< PasswordRow("password") {
                $0.title = "Password"
                $0.add(rule: RuleMinLength(minLength: 8))
                $0.add(rule: RuleMaxLength(maxLength: 30))
                }
                .cellUpdate { cell, row in
                    if !row.isValid {
                        cell.titleLabel?.textColor = .red
                    }
        }
        
        tableView.tableFooterView = UIView()
    }
    
    //MARK: Login User
    @IBAction func btnLogin(_ sender: UIButton) {
        
        let values = form.values().compactMapValues { $0 }
        if !values.isEmpty && form.validate().isEmpty {
            
            // set authorization header
            let username  = values["username"] as! String
            let password  = values["password"] as! String
            Authorization.basic(username: username, secret: password).setHeader()
            
            // call login web service
            loginWebService()
        }
    }
    
    //MARK: Login Web Service
    func loginWebService() {
        showloader()
        let rest = RestManager<User>()
        rest.makeRequest(toURL: API.user.endPoint, withHttpMethod: .get) { [weak self] (result) in
            self?.hideloader()
            switch result {
            case .success:
                self?.switchToHome()
            case .failure(let error):
                if rest.responseHttpHeaders.keys.contains("X-GitHub-OTP") {
                    self?.popup2FAWindow()
                } else {
                    self?.view.makeToast(error.description)
                }
            }
        }
    }
    
    // presents 2-factor authentication popup window
    private func popup2FAWindow() {
        showInputDialog(delegate:self, title: "Authentication", subtitle: "Please enter your authentication code", actionTitle: "Confirm", cancelTitle: "Cancel", inputPlaceholder: "Authentication code", inputKeyboardType: .numberPad, cancelHandler: nil) { (code) in
            guard let code = code else { return }
            self.authorizationWebService(code: code) { [weak self] in
                self?.switchToHome()
            }
        }
    }
    
    //MARK: Authoriation Web Service
    private func authorizationWebService(code: String, completion:@escaping ()->()) {
        self.showloader()
        let rest = RestManager<OAuth>()
        rest.requestHttpHeaders["x-github-otp"] = code
        let params = ["client_id": "3950305f68a264794e74",
                      "client_secret": "bbdc87f574be69b7bb20bc421d3a9f930c1fcf53",
                      "scopes": ["repo"],
                      "note": "admin script"] as [String : Any]
        rest.makeRequest(toURL: API.authorizations.endPoint, params: params, withHttpMethod: .post) { [weak self] (result) in
            self?.hideloader()
            switch result {
            case .success(let auth):
                rest.requestHttpHeaders["x-github-otp"] = nil
                Authorization.bearer(token: auth.token).setHeader()
                completion()
            case .failure:
                self?.view.makeToast("Please enter valid OTP")
            }
        }
    }
    
    // switches root to home
    private func switchToHome() {
        UserDefaults.standard.setLoginStatus(true)
        RootNavigator.sharedInstance.switchToHome()
    }
}

//MARK: UITextField  Delegate
extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 6
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
