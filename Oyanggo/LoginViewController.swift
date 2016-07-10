//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class LoginViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var joinBtn: UIButton!
    @IBOutlet var kakaoLoginBtn: UIButton!
    
    
    override func viewDidLoad() {
        print("LoginViewController viewDidLoad")
        
        
        idField.delegate = self
        pwField.delegate = self
        idField.maxLength(14)
        pwField.maxLength(14)
        loginBtn.boxLayout(radius: 6, borderWidth: 1, borderColor: UIColor.blackColor())
        joinBtn.boxLayout(radius: 6, borderWidth: 1, borderColor: UIColor.blackColor())
        
        kakaoLoginBtn.boxLayout(radius: 4, backgroundColor: UIColor(red:1.00, green:0.93, blue:0.21, alpha:1.00))
        let kakaoLoginImg = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20), image: UIImage(named: "kakaoBtn.png")!)
        kakaoLoginBtn.addSubview(kakaoLoginImg)
    }

    
    
    //카카오톡 로그인 클릭
    @IBAction func kakaoAction(sender: AnyObject) {
        let session: KOSession = KOSession.sharedSession();
        if session.isOpen() {
            session.close()
            Util.alert("", message: "앱을 다시 실행시켜주세요.", confirmTitle: "확인", ctrl: self, confirmHandler: { (_) in
                exit(0)
            })
        }
        session.presentingViewController = self.navigationController
        session.openWithCompletionHandler({ (error) -> Void in
            if error != nil{
                print(error.localizedDescription)
            }else if session.isOpen() == true{
                KOSessionTask.meTaskWithCompletionHandler({ (profile , error) -> Void in
                    if profile != nil{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            func loginFn(sex : String){
                                let kakao : KOUser = profile as! KOUser
                                let user = Storage.copyUser()
                                user.isLogin = 2
                                if let kakaoNickname = kakao.properties["nickname"] as? String{
                                    user.nickName = kakaoNickname
                                }
                                user.userId = String(kakao.ID)
                                user.sex = sex
                                Storage.setRealmUser(user)
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                                let uvc = storyBoard.instantiateViewControllerWithIdentifier("VC")
                                uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                                self.presentViewController(uvc, animated: true, completion: nil)
                            }
                            
                            
                            
                            let alert = UIAlertController(title: "성별을 선택해주세요", message: "", preferredStyle: .ActionSheet)
                            alert.addAction(UIAlertAction(title: "남자", style: .Default, handler: { (alert) in
                                loginFn("male")
                            }))
                            alert.addAction(UIAlertAction(title: "여자", style: .Default, handler: { (alert) in
                                loginFn("female")
                            }))
                            self.presentViewController(alert, animated: false, completion: {(_) in})
                        })
                    }
                })
            }
        })
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


