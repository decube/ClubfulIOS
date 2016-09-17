//
//  SettingViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingViewController : UIViewController{
    
    
    @IBOutlet var tab_1: UIView!
    @IBOutlet var tab_2: UIView!
    @IBOutlet var tab_3: UIView!
    @IBOutlet var tab_4: UIView!
    @IBOutlet var tab_5: UIView!
    @IBOutlet var tab_6: UIView!
    @IBOutlet var tab_7: UIView!
    
    @IBOutlet var signBtn: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SettingViewController viewDidLoad")
        
        signCheck()
        
        borderBottom(tab_1)
        borderBottom(tab_2)
        borderBottom(tab_3)
        borderBottom(tab_4)
        borderBottom(tab_5)
        borderBottom(tab_6)
        borderBottom(tab_7)
    }
    
    func signCheck(){
        let user = Storage.getRealmUser()
        if user.isLogin == -1{
            signBtn.setTitle("로그인", forState: .Normal)
        }else{
            signBtn.setTitle("로그아웃", forState: .Normal)
        }
    }
    
    @IBAction func signAction(sender: AnyObject) {
        var user = Storage.getRealmUser()
        if user.isLogin == -1{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let uvc = storyBoard.instantiateViewControllerWithIdentifier("loginVC")
            uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            (uvc as! LoginViewController).vc = self
            self.presentViewController(uvc, animated: true, completion: nil)
        }else{
            Util.alert(self, title: "알림", message: "로그아웃 하시겠습니까?", confirmTitle: "확인", cancelStr: "취소", confirmHandler: { (alert) in
                let parameters : [String: AnyObject] = ["token": user.token, "userId": user.userId]
                URL.request(self, url: URL.apiServer+URL.api_user_logout, param: parameters)
                
                
                if user.isLogin == 1{
                    //일반로그아웃
                }else if user.isLogin == 2{
                    //카톡로그아웃
                    //KOSessionTask.unlinkTaskWithCompletionHandler({ (success, error) in
                    //
                    //})
                }else if user.isLogin == 3{
                    //페북로그아웃
                    //try! FIRAuth.auth()!.signOut()
                }else if user.isLogin == 4{
                    //네이버로그아웃
                    //
                }
                
                user = Storage.copyUser()
                user.isLogin = -1
                user.nickName = ""
                user.sex = ""
                user.token = ""
                user.birth = NSDate()
                user.userLatitude = 0.0
                user.userLongitude = 0.0
                user.userAddress = ""
                user.userAddressShort = ""
                Storage.setRealmUser(user)
                self.signCheck()
                })
        }
    }
    @IBAction func askAction(sender: AnyObject) {
        func dummyLinkObject() -> [KakaoTalkLinkObject] {
            let image = KakaoTalkLinkObject.createImage("https://developers.kakao.com/assets/img/link_sample.jpg", width: 138, height: 80)
            let androidAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.Android, devicetype: KakaoTalkLinkActionDeviceType.Phone, execparam: [:])
            let iphoneAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.Phone, execparam: [:])
            let ipadAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.Pad, execparam: [:])
            let appLink = KakaoTalkLinkObject.createAppButton("앱 열기", actions: [androidAppAction, iphoneAppAction, ipadAppAction])
            return [image, appLink]
        }
        if KOAppCall.canOpenKakaoTalkAppLink() {
            KOAppCall.openKakaoTalkAppLink(dummyLinkObject())
        } else {
            print("Cannot open kakaotalk.")
        }
    }
    @IBAction func settingAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("appSettingVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    @IBAction func noticeAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("noticeVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    @IBAction func infoAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("infoVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    @IBAction func guideAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("guideVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    @IBAction func inquiryAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("inquiryVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    @IBAction func introAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("eggVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    
    func borderBottom(tab : UIView){
        let border = CALayer()
        border.borderColor = UIColor.grayColor().CGColor
        border.borderWidth = 1
        border.frame = CGRect(x: 0, y: tab.frame.height - 1, width:  tab.frame.width, height: 1)
        tab.layer.addSublayer(border)
        tab.layer.masksToBounds = true
    }
}
