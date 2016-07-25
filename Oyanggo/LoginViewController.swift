//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController, UITextFieldDelegate{
    var mainViewController : ViewController!
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
        }
        session.presentingViewController = self.navigationController
        session.openWithCompletionHandler({ (error) -> Void in
            if error != nil{
                print(error.localizedDescription)
            }else if session.isOpen() == true{
                print("isOpen")
                KOSessionTask.meTaskWithCompletionHandler({ (profile , error) -> Void in
                    if profile != nil{
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            func loginFn(sex : String){
                                let kakao : KOUser = profile as! KOUser
                                var user = Storage.getRealmUser()
                                
                                var nickName = ""
                                if let kakaoNickname = kakao.properties["nickname"] as? String{
                                    nickName = kakaoNickname
                                }
                                
                                let parameters : [String: AnyObject] = ["token": user.token, "userId": String(kakao.ID), "password": "", "loginType": 2, "gcmId": user.gcmId, "nickName": nickName, "sex": sex, "birth": user.birth.getDate(), "userLatitude": user.userLatitude, "userLongitude": user.userLongitude, "userAddress": user.userAddress, "userAddressShort": user.userAddressShort, "noticePush": user.noticePushCheck, "myInsertPush": user.myCourtPushCheck, "distancePush": user.distancePushCheck, "interestPush": user.interestPushCheck, "startTime": user.startPushTime.getTime(), "endTime": user.endPushTime.getTime()]
                                Alamofire.request(.GET, URL.user_login, parameters: parameters)
                                    .validate(statusCode: 200..<300)
                                    .validate(contentType: ["application/json"])
                                    .responseData { response in
                                        let data : NSData = response.data!
                                        let dic = Util.convertStringToDictionary(data)
                                        if let code = dic["code"] as? Int{
                                            if code == 0{
                                                user = Storage.copyUser()
                                                user.isLogin = 2
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
                                                self.mainViewController.loginInit()
                                                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
            }else{
                print("isNotOpen")
            }
        })
    }
    
    //로그인 클릭
    @IBAction func loginAction(sender: AnyObject) {
        if idField.text?.characters.count < 4{
            Util.alert(message: "아이디를 입력해 주세요.", ctrl: self)
        }else if pwField.text?.characters.count < 6{
            Util.alert(message: "비밀번호를 입력해 주세요.", ctrl: self)
        }else{
            var user = Storage.getRealmUser()
            let parameters : [String: AnyObject] = ["token": user.token, "userId": self.idField.text!, "password": self.pwField.text!, "loginType": 1]
            Alamofire.request(.GET, URL.user_login, parameters: parameters)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    let data : NSData = response.data!
                    let dic = Util.convertStringToDictionary(data)
                    if let code = dic["code"] as? Int{
                        if code == 0{
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
                            self.mainViewController.loginInit()
                            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
    }
    
    //회원가입 클릭
    @IBAction func joinAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("joinVC")
        (uvc as! JoinViewController).loginVC = self
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


