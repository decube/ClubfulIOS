//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class AppGuideViewController: UIViewController, UIWebViewDelegate {
    //웹뷰
    @IBOutlet var webView: UIWebView!
    //스핀
    @IBOutlet var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        print("AppGuideViewController viewDidLoad")
        
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        //웹뷰 띄우기
        self.webView.loadRequest(NSURLRequest(URL : NSURL(string: "http://www.naver.com")!))
    }
    
    //웹뷰 가져옴
    func webViewDidFinishLoad(webView: UIWebView) {
        activity.stopAnimating()
        activity.hidden = true
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}


