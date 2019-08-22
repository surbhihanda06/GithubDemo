//
//  Extensions.swift
//  GHDemo
//
//  Created by user on 13/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import UIKit

//MARK: UIViewController
extension UIViewController {
    
    func showInputDialog(delegate: UITextFieldDelegate,
                         title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.phonePad,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
            textField.delegate = delegate
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK: UIImageView
extension UIImageView {
    
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        let indicator = UIActivityIndicatorView(frame: CGRect(x: (bounds.width/2) - 20,
                                                              y: (bounds.height/2) - 20,
                                                              width: 40,
                                                              height: 40))
        indicator.color = .black
        indicator.startAnimating()
        addSubview(indicator)
        contentMode = mode
        backgroundColor = UIColor.groupTableViewBackground
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            DispatchQueue.main.async {
                self.backgroundColor = .clear
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
            
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume() 
    }
    
    func downloaded(from link: String?, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        guard let link = link, let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}

//MARK: UITableView
extension UITableView {
    
    func showBottomLoader() {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: bounds.width, height: CGFloat(44))
        self.tableFooterView = spinner
        self.tableFooterView?.isHidden = false
    }
    
    func hideBottomLoader() {
        self.tableFooterView = UIView()
        self.tableFooterView?.isHidden = true
    }
}

//MARK: UIView
extension UIView {
    
    // Corner Radius 
    @IBInspectable var cornerradius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    //Border Color
    @IBInspectable var borderColor: UIColor {
        set {
            layer.borderColor = newValue.cgColor
        }
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
    }
    
    // Border Width
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
}

//MARK: String
extension String {
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

extension UIStackView {
    
    func hideEmptyLabels() {
        subviews.forEach {
            if $0.isKind(of: UILabel.self) {
                if let text = ($0 as! UILabel).text, text.isEmpty || ($0 as! UILabel).text == nil {
                    $0.isHidden = true
                }
            }
        }
        layoutIfNeeded()
    }
    
    func hideEmptyButtons() {
        subviews.forEach {
            if $0.isKind(of: UIButton.self) {
                var simpleText: String = ""
                var attributedText: String = ""
                if let text = ($0 as! UIButton).titleLabel?.text {
                    simpleText = text
                }
                if let text = ($0 as! UIButton).titleLabel?.attributedText {
                   attributedText = text.string
                }
                $0.isHidden = simpleText.isEmpty && attributedText.isEmpty
            }
        }
        layoutIfNeeded()
    }
}

//MARK: UIButton
extension UIButton {
    
    func createLink(_ url: String) {
        let attributedString = NSAttributedString(string: NSLocalizedString(url, comment: ""), attributes:[
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor : UIColor.blue,
            NSAttributedString.Key.underlineStyle:1.0
            ])
        setAttributedTitle(attributedString, for: .normal)
        titleLabel?.minimumScaleFactor = 0.2
        titleLabel?.lineBreakMode = .byWordWrapping
    }
}
