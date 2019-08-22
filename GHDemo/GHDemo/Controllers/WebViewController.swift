//
//  WebViewController.swift
//  GHDemo
//
//  Created by user on 19/08/19.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import WebKit

/*loads all the web request or web links into webview*/
class WebViewController: UIViewController, ActivityIndicatorViewable {
    
    @IBOutlet var webview: WKWebView!
    
    var indicatorView: ActivityIndicatorView = ActivityIndicatorView()
    var urlString: String? = nil
    var barbutton: UIBarButtonItem!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setupIndicator()
        self.addNavigationBarButtonItem()
        self.loadUrl()
    }
    
    // add navigation bar button item
    func addNavigationBarButtonItem() {
        barbutton = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: .plain, target: self, action: #selector(selector))
        navigationItem.leftBarButtonItem = barbutton
    }
    
    // bar button action
    @objc func selector(_ button : UIBarButtonItem) {
        if webview.canGoBack {
            webview.goBack()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    // load url
    func loadUrl() {
        
        guard let string = urlString, let url = URL(string: string) else {
            return
        }
        
        showloader()
        
        let request = URLRequest(url: url)
        webview.navigationDelegate = self
        webview.load(request)
        webview.allowsBackForwardNavigationGestures = true
        webview.uiDelegate = self
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.scrollView.bounces = false
    }
}

//MARK: WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showloader()
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        self.hideloader()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        self.hideloader()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.hideloader()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
}

//MARK: WKUIDelegate
extension WebViewController: WKUIDelegate {
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        return nil
    }
}
