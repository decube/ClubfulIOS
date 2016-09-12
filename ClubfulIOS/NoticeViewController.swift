//
//  NoticeViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class NoticeViewController : UIViewController, UIWebViewDelegate{
    //웹뷰
    @IBOutlet var webView: UIWebView!
    //스핀
    @IBOutlet var spin: UIActivityIndicatorView!
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("NoticeViewController viewDidLoad")
        
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        //웹뷰 띄우기
        self.webView.loadRequest(NSURLRequest(URL : NSURL(string: "https://pikachu987.github.io/")!))
    }
    
    //웹뷰 가져옴
    func webViewDidFinishLoad(webView: UIWebView) {
        spin.stopAnimating()
        spin.hidden = true
        if self.webView.canGoBack{
            backBtn.setImage(UIImage(named: "ic_left_true.png"), forState: .Normal)
        }else{
            backBtn.setImage(UIImage(named: "ic_left_false.png"), forState: .Normal)
        }
        if self.webView.canGoForward{
            nextBtn.setImage(UIImage(named: "ic_right_true.png"), forState: .Normal)
        }else{
            nextBtn.setImage(UIImage(named: "ic_right_false.png"), forState: .Normal)
        }
    }
    func webViewDidStartLoad(webView: UIWebView) {
        if self.webView.canGoBack{
            backBtn.setImage(UIImage(named: "ic_left_true.png"), forState: .Normal)
        }else{
            backBtn.setImage(UIImage(named: "ic_left_false.png"), forState: .Normal)
        }
        if self.webView.canGoForward{
            nextBtn.setImage(UIImage(named: "ic_right_true.png"), forState: .Normal)
        }else{
            nextBtn.setImage(UIImage(named: "ic_right_false.png"), forState: .Normal)
        }
    }
    
    @IBAction func webBackAction(sender: AnyObject) {
        self.webView.goBack()
    }
    @IBAction func webNextAction(sender: AnyObject) {
        self.webView.goForward()
    }
    @IBAction func webReloadAction(sender: AnyObject) {
        self.webView.reload()
    }
    @IBAction func webLinkAction(sender: AnyObject) {
        if let url = NSURL(string: (self.webView.request?.URL?.absoluteString)!){
            if UIApplication.sharedApplication().canOpenURL(url) {
                UIApplication.sharedApplication().openURL(url)
            }
        }
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}
