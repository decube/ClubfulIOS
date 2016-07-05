//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        print("LoginViewController viewDidLoad")
        
        let loginCenterY = Util.screenSize.height/2
        
        let loginField = UITextField(frame: CGRect(x: 20, y: loginCenterY-45, width: Util.screenSize.width-120, height: 40), placeholder: "아이디를 입력해주세요.", textAlignment: .Left, delegate: self)
        let passwordField = UITextField(frame: CGRect(x: 20, y: loginCenterY+5, width: Util.screenSize.width-120, height: 40), placeholder: "비밀번호를 입력해주세요.", textAlignment: .Left, delegate: self)
        let loginBtn = UIButton(frame: CGRect(x: Util.screenSize.width-90, y: loginCenterY-45, width: 70, height: 50), text: "로그인", color: UIColor.whiteColor())
        let joinBtn = UIButton(frame: CGRect(x: Util.screenSize.width-90, y: loginCenterY+15, width: 70, height: 30), text: "회원가입")
        
        let faceLoginBtn = FBSDKLoginButton(frame: CGRect(x: 20, y: Util.screenSize.height-100, width: Util.screenSize.width-40, height: 40))
        let kakaoLoginBtn = UIButton(frame: CGRect(x: 20, y: Util.screenSize.height-50, width: Util.screenSize.width-40, height: 40), text: "카카오톡으로 로그인", fontSize: 14)
        let kakaoLoginImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20), image: UIImage(named: "kakaoBtn.png")!)
        
        loginField.maxLength(14)
        passwordField.maxLength(14)
        loginField.returnKeyType = UIReturnKeyType.Done
        passwordField.returnKeyType = UIReturnKeyType.Done
        passwordField.secureTextEntry = true
        loginBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: UIColor.blackColor(), borderColor: UIColor.blackColor())
        joinBtn.boxLayout(radius: 6, borderWidth: 1, backgroundColor: UIColor.whiteColor(), borderColor: UIColor.blackColor())
        faceLoginBtn.readPermissions = ["public_profile", "email", "user_friends"]
        faceLoginBtn.setAttributedTitle(NSAttributedString(string: "페이스북으로 로그인"), forState: .Normal)
        kakaoLoginBtn.boxLayout(radius: 4, backgroundColor: UIColor(red:1.00, green:0.93, blue:0.21, alpha:1.00))
        
        self.view.addSubview(loginField)
        self.view.addSubview(passwordField)
        self.view.addSubview(loginBtn)
        self.view.addSubview(joinBtn)
        self.view.addSubview(faceLoginBtn)
        self.view.addSubview(kakaoLoginBtn)
        kakaoLoginBtn.addSubview(kakaoLoginImg)
        
        loginBtn.addControlEvent(.TouchUpInside){
            let user = Storage.copyUser()
            user.isLogin = 1
            Storage.setRealmUser(user)
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let uvc = storyBoard.instantiateViewControllerWithIdentifier("VC")
            uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(uvc, animated: true, completion: nil)
        }
        joinBtn.addControlEvent(.TouchUpInside){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let uvc = storyBoard.instantiateViewControllerWithIdentifier("joinVC")
            uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(uvc, animated: true, completion: nil)
        }
        faceLoginBtn.addControlEvent(.TouchUpInside){
            let user = Storage.copyUser()
            user.isLogin = 2
            Storage.setRealmUser(user)
        }
        kakaoLoginBtn.addControlEvent(.TouchUpInside){
            let user = Storage.copyUser()
            user.isLogin = 3
            Storage.setRealmUser(user)
            
            let session: KOSession = KOSession.sharedSession();
            if session.isOpen() {
                session.close()
            }
            session.presentingViewController = self.navigationController
            session.openWithCompletionHandler({ (error) -> Void in
                session.presentingViewController = nil
                if !session.isOpen() {
                    Util.alert(message: error.localizedDescription, ctrl: self)
                }
            }, authParams: nil, authTypes: [KOAuthType.Talk.rawValue, KOAuthType.Account.rawValue])
        }
        
        
        
        
        
        CustomView.initLayout(self, title: "로그인")
    }
    
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


