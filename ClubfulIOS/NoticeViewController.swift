//
//  NoticeViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class NoticeViewController : UIViewController{
    @IBOutlet var webView: UIWebView!
    @IBOutlet var spin: UIActivityIndicatorView!
    
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var nextBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        //웹뷰 띄우기
        self.webView.loadRequest(URLRequest(url : Foundation.URL(string: URLReq.apiServer+"wv/notice.html")!))
    }
    
    @IBAction func webBackAction(_ sender: AnyObject) {
        self.webView.goBack()
    }
    @IBAction func webNextAction(_ sender: AnyObject) {
        self.webView.goForward()
    }
    @IBAction func webReloadAction(_ sender: AnyObject) {
        self.webView.reload()
    }
    @IBAction func webLinkAction(_ sender: AnyObject) {
        if let url = Foundation.URL(string: (self.webView.request?.url?.absoluteString)!){
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //제스처
    var interactor:Interactor? = nil
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
}


extension NoticeViewController : UIWebViewDelegate{
    //웹뷰 가져옴
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spin.stopAnimating()
        spin.isHidden = true
        if self.webView.canGoBack{
            backBtn.setImage(UIImage(named: "wb_left_on"), for: UIControlState())
        }else{
            backBtn.setImage(UIImage(named: "wb_left_off"), for: UIControlState())
        }
        if self.webView.canGoForward{
            nextBtn.setImage(UIImage(named: "wb_right_on"), for: UIControlState())
        }else{
            nextBtn.setImage(UIImage(named: "wb_right_off"), for: UIControlState())
        }
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        if self.webView.canGoBack{
            backBtn.setImage(UIImage(named: "wb_left_on"), for: UIControlState())
        }else{
            backBtn.setImage(UIImage(named: "wb_left_off"), for: UIControlState())
        }
        if self.webView.canGoForward{
            nextBtn.setImage(UIImage(named: "wb_right_on"), for: UIControlState())
        }else{
            nextBtn.setImage(UIImage(named: "wb_right_off"), for: UIControlState())
        }
    }
}
