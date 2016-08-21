//
//  GuideViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class GuideViewController : UIViewController, UIWebViewDelegate{
    //웹뷰
    @IBOutlet var webView: UIWebView!
    //스핀
    @IBOutlet var spin: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("GuideViewController viewDidLoad")
        
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        //웹뷰 띄우기
        self.webView.loadRequest(NSURLRequest(URL : NSURL(string: "https://pikachu987.github.io/")!))
    }
    
    //웹뷰 가져옴
    func webViewDidFinishLoad(webView: UIWebView) {
        spin.stopAnimating()
        spin.hidden = true
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}