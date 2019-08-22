//
//  ActivityIndicatorViewable.swift
//  GHDemo
//
//  Created by user on 13/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import UIKit


// protocol for uiactivity indicator veiw
protocol ActivityIndicatorViewable {
    var indicatorView: ActivityIndicatorView { set get }
    func setupIndicator()
    func showloader()
    func showloader(color: UIColor)
    func hideloader()
}

extension ActivityIndicatorViewable where Self : UIViewController {
    
    // setup activity indicator
    func setupIndicator() {
        self.view.layoutIfNeeded()
        self.indicatorView.setup(with: view.bounds)
        self.view.addSubview(indicatorView)
    }
    
    // show activity indicator
    func showloader() {
        self.indicatorView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        self.indicatorView.isHidden = false
        self.indicatorView.indicator.startAnimating()
    }
    
    func showloader(color: UIColor) {
        self.indicatorView.backgroundColor = color
        self.indicatorView.isHidden = false
        self.indicatorView.indicator.startAnimating()
    }
    
    // hide activity indicator
    func hideloader() {
        self.indicatorView.isHidden = true
        self.indicatorView.indicator.stopAnimating()
    }
}

//MARK: Activity Indicator Viewable Class
class ActivityIndicatorView: UIView {
    
    var indicator: UIActivityIndicatorView!
    
    init() {
        super.init(frame: CGRect.zero)
        self.indicator = UIActivityIndicatorView()
    }
    
    func setup(with viewframe: CGRect) {
        isHidden = true
        frame = viewframe
        indicator.center = center
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        indicator.color = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        addSubview(indicator)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
