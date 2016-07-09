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
    
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var joinBtn: UIButton!
    @IBOutlet var faceLoginBtn: FBSDKLoginButton!
    @IBOutlet var kakaoLoginBtn: UIButton!
    
    
    override func viewDidLoad() {
        print("LoginViewController viewDidLoad")
        
        
        idField.delegate = self
        pwField.delegate = self
        idField.maxLength(14)
        pwField.maxLength(14)
        loginBtn.boxLayout(radius: 6, borderWidth: 1, borderColor: UIColor.blackColor())
        joinBtn.boxLayout(radius: 6, borderWidth: 1, borderColor: UIColor.blackColor())
        
        
        
        
        faceLoginBtn.readPermissions = ["public_profile", "email", "user_friends"]
        faceLoginBtn.setAttributedTitle(NSAttributedString(string: "페이스북으로 로그인"), forState: .Normal)
        kakaoLoginBtn.boxLayout(radius: 4, backgroundColor: UIColor(red:1.00, green:0.93, blue:0.21, alpha:1.00))
        let kakaoLoginImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20), image: UIImage(named: "kakaoBtn.png")!)
        
        kakaoLoginBtn.addSubview(kakaoLoginImg)
    }
    
    //카카오톡 로그인 클릭
    @IBAction func kakaoAction(sender: AnyObject) {
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
    
    //로그인 클릭
    @IBAction func loginAction(sender: AnyObject) {
        let user = Storage.copyUser()
        user.isLogin = 1
        Storage.setRealmUser(user)
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("VC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    
    //회원가입 클릭
    @IBAction func joinAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("joinVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


