//
//  InfoViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


class InfoViewController : UIViewController, UIWebViewDelegate{
    @IBOutlet var currentAppVersionLbl: UILabel!
    @IBOutlet var newAppVersionLbl: UILabel!
    @IBOutlet var appVersionBtn: UIButton!
    var isVersionUpdate = false
    
    //웹뷰
    @IBOutlet var webView: UIWebView!
    //스핀
    @IBOutlet var spin: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("InfoViewController viewDidLoad")
        
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        //웹뷰 띄우기
        self.webView.loadRequest(URLRequest(url : Foundation.URL(string: URL.viewServer+URL.view_info)!))
        
        setLayout()
        
        let user = Storage.getRealmUser()
        
        let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "appType": "ios" as AnyObject]
        URL.request(self, url: URL.apiServer+URL.api_version_app, param: parameters, callback: { (dic) in
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
        if newAppVerNum <= currnetAppNum{
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
