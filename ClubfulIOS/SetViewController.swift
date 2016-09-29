//
//  SetViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class SetViewController : UIViewController{
    
    @IBOutlet var tab_0: UIView!
    @IBOutlet var tab_1: UIView!
    @IBOutlet var tab_2: UIView!
    @IBOutlet var tab_3: UIView!
    @IBOutlet var tab_4: UIView!
    @IBOutlet var tab_5: UIView!
    @IBOutlet var tab_6: UIView!
    @IBOutlet var tab_7: UIView!
    @IBOutlet var signLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SetViewController viewDidLoad")
        
        signCheck()
        
        self.tab_3.isUserInteractionEnabled = true
        self.tab_1.isUserInteractionEnabled = true
        self.tab_2.isUserInteractionEnabled = true
        self.tab_3.isUserInteractionEnabled = true
        self.tab_4.isUserInteractionEnabled = true
        self.tab_5.isUserInteractionEnabled = true
        self.tab_6.isUserInteractionEnabled = true
        self.tab_7.isUserInteractionEnabled = true
        self.tab_0.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.signAction(_:))))
        self.tab_1.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.askAction(_:))))
        self.tab_2.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.settingAction(_:))))
        self.tab_3.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.noticeAction(_:))))
        self.tab_4.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.infoAction(_:))))
        self.tab_5.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.guideAction(_:))))
        self.tab_6.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.inquiryAction(_:))))
        self.tab_7.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.introAction(_:))))
//
        
    }
    
    func signCheck(){
        let user = Storage.getRealmUser()
        if user.isLogin == -1{
            signLbl.text = "로그인"
        }else{
            signLbl.text = "로그아웃"
        }
    }

    func signAction(_ sender: AnyObject) {
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

    
    func askAction(_ sender: AnyObject) {
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
    func settingAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "appSettingVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    func noticeAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "noticeVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    func infoAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "infoVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    func guideAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "guideVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    func inquiryAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "inquiryVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    func introAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "eggVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
}
