//
//  InfoViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire

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
        self.webView.loadRequest(NSURLRequest(URL : NSURL(string: "https://pikachu987.github.io/")!))
        
        setLayout()
        
        let user = Storage.getRealmUser()
        
        let parameters : [String: AnyObject] = ["token": user.token, "appType": "ios"]
        Alamofire.request(.GET, URL.version_app, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data!
                let dic = Util.convertStringToDictionary(data)
                if let code = dic["code"] as? Int{
                    if code == 0{
                        Util.newVersion = dic["appVersion"] as! String
                        dispatch_async(dispatch_get_main_queue()) {
                            self.setLayout()
                        }
                    }else{
                        if let isMsgView = dic["isMsgView"] as? Bool{
                            if isMsgView == true{
                                Util.alert(self, message: "\(dic["msg"]!)")
                            }
                        }
                    }
                }
        }
        
        
    }
    
    func setLayout(){
        let newAppVer = Util.newVersion
        let currnetAppVer = Util.nsVersion
        let newAppVerNum = Int(newAppVer.stringByReplacingOccurrencesOfString(".", withString: ""))
        let currnetAppNum = Int(currnetAppVer.stringByReplacingOccurrencesOfString(".", withString: ""))
        if newAppVerNum <= currnetAppNum{
            currentAppVersionLbl.text = currnetAppVer
            newAppVersionLbl.text = currnetAppVer
            appVersionBtn.setTitle("최신버전입니다.", forState: .Normal)
            isVersionUpdate = false
        }else{
            currentAppVersionLbl.text = currnetAppVer
            newAppVersionLbl.text = newAppVer
            appVersionBtn.setTitle("버전 업데이트", forState: .Normal)
            isVersionUpdate = true
        }
    }
    
    @IBAction func appVersionAction(sender: AnyObject) {
        if isVersionUpdate == true{
            print("업데이트 페이지 연결")
        }
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
