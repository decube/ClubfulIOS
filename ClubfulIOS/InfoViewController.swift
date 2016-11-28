//
//  InfoViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class InfoViewController : UIViewController{
    @IBOutlet var currentAppVersionLbl: UILabel!
    @IBOutlet var newAppVersionLbl: UILabel!
    @IBOutlet var appVersionBtn: UIButton!
    var isVersionUpdate = false
    
    @IBOutlet var webView: UIWebView!
    @IBOutlet var spin: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        //웹뷰 띄우기
        self.webView.loadRequest(URLRequest(url : Foundation.URL(string: URLReq.viewServer+URLReq.view_info)!))
        
        self.setLayout()
        
        let parameters : [String: AnyObject] = ["appType": "ios" as AnyObject]
        URLReq.request(self, url: URLReq.apiServer+URLReq.api_version_app, param: parameters, callback: { (dic) in
            Util.newVersion = dic["appVersion"] as! String
            DispatchQueue.main.async {
                self.setLayout()
            }
        })
    }
    
    func setLayout(){
        let newAppVer = Util.newVersion
        let currnetAppVer = Util.nsVersion
        let newAppVerNum = Int((newAppVer?.replacingOccurrences(of: ".", with: ""))!)
        let currnetAppNum = Int(currnetAppVer.replacingOccurrences(of: ".", with: ""))
        if newAppVerNum! <= currnetAppNum!{
            currentAppVersionLbl.text = currnetAppVer
            newAppVersionLbl.text = currnetAppVer
            appVersionBtn.setTitle("최신버전입니다.", for: UIControlState())
            isVersionUpdate = false
        }else{
            currentAppVersionLbl.text = currnetAppVer
            newAppVersionLbl.text = newAppVer
            appVersionBtn.setTitle("버전 업데이트", for: UIControlState())
            isVersionUpdate = true
        }
    }
    
    @IBAction func appVersionAction(_ sender: AnyObject) {
        if isVersionUpdate == true{
            print("업데이트 페이지 연결")
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

extension InfoViewController : UIWebViewDelegate{
    //웹뷰 가져옴
    func webViewDidFinishLoad(_ webView: UIWebView) {
        spin.stopAnimating()
        spin.isHidden = true
    }
}
