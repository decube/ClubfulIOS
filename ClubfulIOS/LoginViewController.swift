//
//  LoginViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var spin: UIActivityIndicatorView!
    var vc : SettingViewController!
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var joinBtn: UIButton!
    @IBOutlet var kakaoLoginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController viewDidLoad")
        
        spin.hidden = true
        
        idField.delegate = self
        pwField.delegate = self
        idField.maxLength(14)
        pwField.maxLength(14)
    }
    
    
    
    
    
    //로그인
    func login(userId: String, nickName: String, loginType: Int){
        var user = Storage.getRealmUser()
        let parameters : [String: AnyObject] = ["token": user.token, "userId": userId, "password": "", "loginType": 2, "gcmId": user.gcmId, "nickName": nickName, "sex": "", "birth": user.birth.getDate(), "userLatitude": user.userLatitude, "userLongitude": user.userLongitude, "userAddress": user.userAddress, "userAddressShort": user.userAddressShort, "noticePush": user.noticePushCheck, "myInsertPush": user.myCourtPushCheck, "distancePush": user.distancePushCheck, "interestPush": user.interestPushCheck, "startTime": user.startPushTime.getTime(), "endTime": user.endPushTime.getTime()]
        
        URL.request(self, url: URL.apiServer+URL.api_user_login, param: parameters, callback: { (dic) in
            user = Storage.copyUser()
            user.isLogin = loginType
            user.userId = dic["userId"] as! String
            user.nickName = dic["nickName"] as! String
            user.sex = dic["sex"] as! String
            user.userLatitude = dic["userLatitude"] as! Double
            user.userLongitude = dic["userLongitude"] as! Double
            user.userAddress = dic["userAddress"] as! String
            user.userAddressShort = dic["userAddressShort"] as! String
            
            let dateMakerFormatter = NSDateFormatter()
            dateMakerFormatter.calendar = NSCalendar.currentCalendar()
            dateMakerFormatter.dateFormat = "yyyy-MM-dd"
            user.birth = dateMakerFormatter.dateFromString("\(dic["birth"] as! String)")!
            
            
            user.noticePushCheck = dic["noticePush"] as! Bool
            user.myCourtPushCheck = dic["myCreateCourtPush"] as! Bool
            user.distancePushCheck = dic["distancePush"] as! Bool
            user.interestPushCheck = dic["interestPush"] as! Bool
            
            let dateMakerFormatter2 = NSDateFormatter()
            dateMakerFormatter2.calendar = NSCalendar.currentCalendar()
            dateMakerFormatter2.dateFormat = "hh:mm:ss"
            
            user.startPushTime = dateMakerFormatter2.dateFromString("\(dic["startTime"] as! String)")!
            user.endPushTime = dateMakerFormatter2.dateFromString("\(dic["endTime"] as! String)")!
            
            Storage.setRealmUser(user)
            self.vc.signCheck()
            self.spin.hidden = true
            self.spin.stopAnimating()
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }, codeErrorCallback: {(dic) in
            self.spin.hidden = true
            self.spin.stopAnimating()
        })
    }
    
    
    
    
    
    
    //카카오톡 로그인 클릭
    @IBAction func kakaoAction(sender: AnyObject) {
        if spin.hidden == false{
            return
        }
        spin.hidden = false
        spin.startAnimating()
        let session: KOSession = KOSession.sharedSession();
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = self
        session.openWithCompletionHandler({ (error) -> Void in
            self.spin.hidden = true
            self.spin.stopAnimating()
            if error != nil{
                print(error.localizedDescription)
            }else if session.isOpen() == true{
                KOSessionTask.meTaskWithCompletionHandler({ (profile , error) -> Void in
                    if profile != nil{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            let kakao : KOUser = profile as! KOUser
                            var nickName = ""
                            if let kakaoNickname = kakao.properties["nickname"] as? String{
                                nickName = kakaoNickname
                            }
                            self.login(String(kakao.ID), nickName: nickName, loginType: 2)
                        })
                    }
                })
            }else{
                print("isNotOpen")
            }
        })
    }
    //페이스북 로그인 클릭
    @IBAction func facebookAction(sender: AnyObject) {
        if spin.hidden == false{
            return
        }
        spin.hidden = false
        spin.startAnimating()
        let login = FBSDKLoginManager()
        login.logInWithReadPermissions(["public_profile"], fromViewController: self, handler: { (result, error) in
            self.spin.hidden = true
            self.spin.stopAnimating()
            if error != nil{
                print("Facebook login failed. Error \(error)")
            } else if result.isCancelled {
                print("Facebook login isCancelled. result \(result.token)")
            } else {
                let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
                FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                    if error != nil {
                        print("Login failed. \(error)")
                    } else {
                        var nickName = "", uid = ""
                        if let faceNickname = user?.displayName{
                            nickName = faceNickname
                        }
                        if let faceUid = user?.uid{
                            uid = faceUid
                        }
                        self.login(uid, nickName: nickName, loginType: 3)
                    }
                }
            }
        })
    }
    
    
    
    
    
    
    //로그인 클릭
    @IBAction func loginAction(sender: AnyObject) {
        if spin.hidden == false{
            return
        }
        if idField.text?.characters.count < 4{
            Util.alert(self, message: "아이디를 입력해 주세요.")
        }else if pwField.text?.characters.count < 6{
            Util.alert(self, message: "비밀번호를 입력해 주세요.")
        }else{
            var user = Storage.getRealmUser()
            self.spin.hidden = false
            self.spin.startAnimating()
            let parameters : [String: AnyObject] = ["token": user.token, "userId": self.idField.text!, "password": self.pwField.text!, "loginType": 1]
            
            URL.request(self, url: URL.apiServer+URL.api_user_login, param: parameters, callback: { (dic) in
                user = Storage.copyUser()
                user.isLogin = 1
                user.userId = dic["userId"] as! String
                user.nickName = dic["nickName"] as! String
                user.sex = dic["sex"] as! String
                user.userLatitude = dic["userLatitude"] as! Double
                user.userLongitude = dic["userLongitude"] as! Double
                user.userAddress = dic["userAddress"] as! String
                user.userAddressShort = dic["userAddressShort"] as! String
                
                let dateMakerFormatter = NSDateFormatter()
                dateMakerFormatter.calendar = NSCalendar.currentCalendar()
                dateMakerFormatter.dateFormat = "yyyy-MM-dd"
                user.birth = dateMakerFormatter.dateFromString("\(dic["birth"] as! String)")!
                
                
                user.noticePushCheck = dic["noticePush"] as! Bool
                user.myCourtPushCheck = dic["myCreateCourtPush"] as! Bool
                user.distancePushCheck = dic["distancePush"] as! Bool
                user.interestPushCheck = dic["interestPush"] as! Bool
                
                let dateMakerFormatter2 = NSDateFormatter()
                dateMakerFormatter2.calendar = NSCalendar.currentCalendar()
                dateMakerFormatter2.dateFormat = "hh:mm:ss"
                
                user.startPushTime = dateMakerFormatter2.dateFromString("\(dic["startTime"] as! String)")!
                user.endPushTime = dateMakerFormatter2.dateFromString("\(dic["endTime"] as! String)")!
                
                Storage.setRealmUser(user)
                self.vc.signCheck()
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }, codeErrorCallback: { (dic) in
                self.spin.hidden = true
                self.spin.stopAnimating()
            })
        }
    }
    
    //회원가입 클릭
    @IBAction func joinAction(sender: AnyObject) {
        if spin.hidden == false{
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("joinVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        (uvc as! JoinViewController).loginVC = self
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
