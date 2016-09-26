//
//  InquiryViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class InquiryViewController : UIViewController, UIWebViewDelegate{
    //웹뷰
    @IBOutlet var webView: UIWebView!
    //스핀
    @IBOutlet var spin: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("InquiryViewController viewDidLoad")
        
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        //웹뷰 띄우기
        self.webView.loadRequest(URLRequest(url : Foundation.URL(string: URL.viewServer+URL.view_inquiry)!))
    }
    
    //웹뷰 가져옴
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spin.stopAnimating()
        spin.isHidden = true
    }
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
