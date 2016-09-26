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
            signBtn.setTitle("로그인", for: UIControlState())
        }else{
            signBtn.setTitle("로그아웃", for: UIControlState())
        }
    }
    
    @IBAction func signAction(_ sender: AnyObject) {
        var user = Storage.getRealmUser()
        if user.isLogin == -1{
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let uvc = storyBoard.instantiateViewController(withIdentifier: "loginVC")
            uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            (uvc as! LoginViewController).vc = self
            self.present(uvc, animated: true, completion: nil)
        }else{
            Util.alert(self, title: "알림", message: "로그아웃 하시겠습니까?", confirmTitle: "확인", cancelStr: "취소", confirmHandler: { (alert) in
                let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "userId": user.userId as AnyObject]
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
                user.birth = Date()
                user.userLatitude = 0.0
                user.userLongitude = 0.0
                user.userAddress = ""
                user.userAddressShort = ""
                Storage.setRealmUser(user)
                self.signCheck()
                })
        }
    }
    @IBAction func askAction(_ sender: AnyObject) {
        func dummyLinkObject() -> [KakaoTalkLinkObject] {
            let image = KakaoTalkLinkObject.createImage("https://developers.kakao.com/assets/img/link_sample.jpg", width: 138, height: 80)
            let androidAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.android, devicetype: KakaoTalkLinkActionDeviceType.phone, execparam: [:])
            let iphoneAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.phone, execparam: [:])
            let ipadAppAction = KakaoTalkLinkAction.createAppAction(KakaoTalkLinkActionOSPlatform.IOS, devicetype: KakaoTalkLinkActionDeviceType.pad, execparam: [:])
            let appLink = KakaoTalkLinkObject.createAppButton("앱 열기", actions: [androidAppAction, iphoneAppAction, ipadAppAction])
            return [image!, appLink!]
        }
        if KOAppCall.canOpenKakaoTalkAppLink() {
            KOAppCall.openKakaoTalkAppLink(dummyLinkObject())
        } else {
            print("Cannot open kakaotalk.")
        }
    }
    @IBAction func settingAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "appSettingVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    @IBAction func noticeAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "noticeVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    @IBAction func infoAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "infoVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    @IBAction func guideAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "guideVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    @IBAction func inquiryAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "inquiryVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    @IBAction func introAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "eggVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    
    func borderBottom(_ tab : UIView){
        let border = CALayer()
        border.borderColor = UIColor.gray.cgColor
        border.borderWidth = 1
        border.frame = CGRect(x: 0, y: tab.frame.height - 1, width:  tab.frame.width, height: 1)
        tab.layer.addSublayer(border)
        tab.layer.masksToBounds = true
    }
}
