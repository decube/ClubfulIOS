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
    let interactor = Interactor()
    
    @IBOutlet var tab_0: UIView!
    @IBOutlet var tab_1: UIView!
    @IBOutlet var tab_2: UIView!
    @IBOutlet var tab_3: UIView!
    @IBOutlet var tab_4: UIView!
    @IBOutlet var tab_5: UIView!
    @IBOutlet var tab_6: UIView!
    @IBOutlet var signLbl: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.signCheck()
        
        self.tab_0.isUserInteractionEnabled = true
        self.tab_1.isUserInteractionEnabled = true
        self.tab_2.isUserInteractionEnabled = true
        self.tab_3.isUserInteractionEnabled = true
        self.tab_4.isUserInteractionEnabled = true
        self.tab_5.isUserInteractionEnabled = true
        self.tab_6.isUserInteractionEnabled = true 
        self.tab_0.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.signAction(_:))))
        self.tab_1.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.askAction(_:))))
        self.tab_2.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.settingAction(_:))))
        self.tab_3.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.noticeAction(_:))))
        self.tab_4.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.infoAction(_:))))
        self.tab_5.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.guideAction(_:))))
        self.tab_6.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.inquiryAction(_:))))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.vc = self
    }
    
    func signCheck(){
        if !Storage.isRealmUser(){
            signLbl.text = "로그인"
        }else{
            signLbl.text = "로그아웃"
        }
    }

    func signAction(_ sender: AnyObject) {
        let user = Storage.getRealmUser()
        if !Storage.isRealmUser(){
            self.performSegue(withIdentifier: "set_login", sender: nil)
        }else{
            Util.alert(self, title: "알림", message: "로그아웃 하시겠습니까?", confirmTitle: "확인", cancelStr: "취소", confirmHandler: { (alert) in
                let parameters : [String: AnyObject] = ["userId": user.userId as AnyObject]
                URLReq.request(self, url: URLReq.apiServer+URLReq.api_user_logout, param: parameters)
                
                Storage.removeReamlUserData()
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
            let appLink = KakaoTalkLinkObject.createAppButton("앱 열기", actions: [androidAppAction!, iphoneAppAction!, ipadAppAction!])
            return [image!, appLink!]
        }
        if KOAppCall.canOpenKakaoTalkAppLink() {
            KOAppCall.openKakaoTalkAppLink(dummyLinkObject())
        }
    }
    func settingAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "set_appSetting", sender: nil)
    }
    func noticeAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "set_notice", sender: nil)
    }
    func infoAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "set_info", sender: nil)
    }
    func guideAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "set_guide", sender: nil)
    }
    func inquiryAction(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "set_inquiry", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LoginViewController{
            vc.vc = self
        }else if let vc = segue.destination as? NoticeViewController{
            vc.transitioningDelegate = self
            vc.interactor = interactor
        }else if let vc = segue.destination as? GuideViewController{
            vc.transitioningDelegate = self
            vc.interactor = interactor
        }else if let vc = segue.destination as? InfoViewController{
            vc.transitioningDelegate = self
            vc.interactor = interactor
        }else if let vc = segue.destination as? InquiryViewController{
            vc.transitioningDelegate = self
            vc.interactor = interactor
        }else if let vc = segue.destination as? AppSettingViewController{
            vc.transitioningDelegate = self
            vc.interactor = interactor
        }
    }
}

extension SetViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator(direction: .left)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}
