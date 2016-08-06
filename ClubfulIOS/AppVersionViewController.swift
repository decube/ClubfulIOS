//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire

class AppVersionViewController: UIViewController {
    @IBOutlet var currentAppVersionLbl: UILabel!
    @IBOutlet var newAppVersionLbl: UILabel!
    @IBOutlet var appVersionBtn: UIButton!
    @IBOutlet var termsTextView: UITextView!
    @IBOutlet var terms1Btn: UIButton!
    @IBOutlet var terms2Btn: UIButton!
    @IBOutlet var terms3Btn: UIButton!
    var isVersionUpdate = false
    override func viewDidLoad() {
        print("AppVersionViewController viewDidLoad")
        setLayout()
        
        terms1Action(terms1Btn)
        
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
                                Util.alert(message: "\(dic["msg"]!)", ctrl: self)
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
        termsTextView.boxLayout(radius: 6, borderWidth: 1, borderColor: UIColor.blackColor())
        termsAction(self.terms1Btn)
    }
    
    @IBAction func appVersionAction(sender: AnyObject) {
        if isVersionUpdate == true{
            print("업데이트 페이지 연결")
        }
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //약관 클릭
    func termsAction(sender: UIButton){
        terms1Btn.backgroundColor = Util.commonColor
        terms2Btn.backgroundColor = Util.commonColor
        terms3Btn.backgroundColor = Util.commonColor
        sender.backgroundColor = UIColor.blackColor()
        termsTextView.scrollToTop()
    }
    
    //약관 1 클릭
    @IBAction func terms1Action(sender: UIButton) {
        termsTextView.text = "11111ㄹㄹㅇㅎㄴㅇㄹㅎㅇㄹㅎㄴㄹ아ㅓ하ㅣㄹㅇ너히ㅏ얼니ㅏ허하ㅣㅓㄹㅇ니ㅏ헐ㅇ니ㅏㅎㄹㅇㅎㄹㅇㅎㄹㅇㄴㅎㅎㄹㅇㅎㅎㅇㅎㅇㄹㄴㅎㄹ11111111"
        termsAction(sender)
    }
    //약관 2 클릭
    @IBAction func terms2Action(sender: UIButton) {
        termsTextView.text = "ㅇㄴㅁㄹㅁㅇㄴㄹㄴㅁㄹㅁㅇㄴㄹㄴㅁ231213213123213123131231321312"
        termsAction(sender)
    }
    //약관 3 클릭
    @IBAction func terms3Action(sender: UIButton) {
        termsTextView.text = "ㄴㅇㄹ아니머랴이너랸ㅇ;머ㅑ랭뇌랴ㅕㅇ노ㅕㅑㄹ홍ㄴ며ㅑ홀여ㅑ홍려ㅑ노햐ㅕㅇㄹ노혀ㅑㄹㅇ노햐ㅕㄹ오햐ㅕㅣㄹ오혀ㅑㅇ롷ㅇ론힐외혼햐ㅣㅕㄷ고ㅑㅣㅕㅗ햐ㅕㅣㄱ도혀ㅑㅣ햐ㅣㄱㄷㅎㄱㅎㅇㄹㄴㅎㄹㅇㅎㄹㅇㅎㄹㅇㅎㅇㄹ하렁니ㅏ헐ㅇ넣ㄹ아ㅣ;ㅓㅎㄹㅇ1111111"
        termsAction(sender)
    }
}


