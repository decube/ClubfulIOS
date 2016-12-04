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

class LoginViewController: UIViewController {
    @IBOutlet var spin: UIActivityIndicatorView!
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    
    @IBOutlet var kakaoLogin: UIView!
    @IBOutlet var facebookLogin: UIView!
    
    var loginCallback: ((Void)->Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        spin.isHidden = true
        
        idField.delegate = self
        pwField.delegate = self
        idField.maxLength(14)
        pwField.maxLength(14)
        
        
        self.kakaoLogin.isUserInteractionEnabled = true
        self.kakaoLogin.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.kakaoAction(_:))))
        self.facebookLogin.isUserInteractionEnabled = true
        self.facebookLogin.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.facebookAction(_:))))
    }
    
    
    
    //로그인 클릭
    @IBAction func loginAction(_ sender: AnyObject) {
        if spin.isHidden == false{
            return
        }
        if (idField.text?.characters.count)! < 4{
            Util.alert(self, message: "아이디를 입력해 주세요.")
        }else if (pwField.text?.characters.count)! < 6{
            Util.alert(self, message: "비밀번호를 입력해 주세요.")
        }else{
            self.spin.isHidden = false
            self.spin.startAnimating()
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(self.idField.text! as AnyObject, forKey: "userId")
            parameters.updateValue(self.pwField.text! as AnyObject as AnyObject, forKey: "password")
            parameters.updateValue("n" as AnyObject as AnyObject, forKey: "loginType")
            
            URLReq.request(self, url: URLReq.apiServer+"certification/login", param: parameters, callback: { (dic) in
                self.loginCallback("n", dic: dic)
            }, codeErrorCallback: { (dic) in
                self.spin.isHidden = true
                self.spin.stopAnimating()
            })
        }
    }
    
    //로그인
    func login(_ userId: String, nickName: String, loginType: String){
        let deviceUser = Storage.getRealmDeviceUser()
        var parameters : [String: AnyObject] = [:]
        parameters.updateValue(userId as AnyObject, forKey: "userId")
        parameters.updateValue("" as AnyObject, forKey: "password")
        parameters.updateValue(loginType as AnyObject, forKey: "loginType")
        parameters.updateValue(deviceUser.pushID as AnyObject, forKey: "gcmId")
        parameters.updateValue(nickName as AnyObject, forKey: "nickName")
        parameters.updateValue(deviceUser.noticePushCheck as AnyObject, forKey: "noticePush")
        parameters.updateValue(deviceUser.myCourtPushCheck as AnyObject, forKey: "myInsertPush")
        parameters.updateValue(deviceUser.distancePushCheck as AnyObject, forKey: "distancePush")
        parameters.updateValue(deviceUser.interestPushCheck as AnyObject, forKey: "interestPush")
        parameters.updateValue(deviceUser.startPushTime.getTime() as AnyObject, forKey: "startTime")
        parameters.updateValue(deviceUser.endPushTime.getTime() as AnyObject, forKey: "endTime")
        
        URLReq.request(self, url: URLReq.apiServer+"certification/login", param: parameters, callback: { (dic) in
            self.loginCallback(loginType, dic: dic)
        }, codeErrorCallback: {(dic) in
            self.spin.isHidden = true
            self.spin.stopAnimating()
        })
    }
    
    func loginCallback(_ loginType: String, dic: [String: AnyObject]){
        let user = Storage.getRealmUser()
        let deviceUser = Storage.getRealmDeviceUser()
        user.loginType = loginType
        user.userId = dic["userId"] as! String
        user.nickName = dic["nickName"] as! String
        user.sex = dic["sex"] as! String
        user.userLatitude = dic["userLatitude"] as! Double
        user.userLongitude = dic["userLongitude"] as! Double
        user.userAddress = dic["userAddress"] as! String
        user.userAddressShort = dic["userAddressShort"] as! String
        
        let dateMakerFormatter = DateFormatter()
        dateMakerFormatter.calendar = Calendar.current
        dateMakerFormatter.dateFormat = "yyyy-MM-dd"
        user.birth = dateMakerFormatter.date(from: "\(dic["birth"] as! String)")!
        
        
        deviceUser.noticePushCheck = dic["noticePush"] as! Bool
        deviceUser.myCourtPushCheck = dic["myCreateCourtPush"] as! Bool
        deviceUser.distancePushCheck = dic["distancePush"] as! Bool
        deviceUser.interestPushCheck = dic["interestPush"] as! Bool
        
        let dateMakerFormatter2 = DateFormatter()
        dateMakerFormatter2.calendar = Calendar.current
        dateMakerFormatter2.dateFormat = "hh:mm:ss"
        
        deviceUser.startPushTime = dateMakerFormatter2.date(from: "\(dic["startTime"] as! String)")!
        deviceUser.endPushTime = dateMakerFormatter2.date(from: "\(dic["endTime"] as! String)")!
        
        Storage.setRealmUser(user)
        Storage.setRealmDeviceUser(deviceUser)
        self.spin.isHidden = true
        self.spin.stopAnimating()
        if self.loginCallback != nil{
            self.loginCallback()
        }
        MypageViewController.isReload = true
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    //카카오톡 로그인 클릭
    func kakaoAction(_ sender: AnyObject) {
        if spin.isHidden == false{
            return
        }
        spin.isHidden = false
        spin.startAnimating()
        let session: KOSession = KOSession.shared();
        if session.isOpen() {
            session.close()
        }
        session.presentingViewController = self
        session.open(completionHandler: { (error) -> Void in
            if error != nil{
                self.spin.isHidden = true
                self.spin.stopAnimating()
            }else if session.isOpen() == true{
                KOSessionTask.meTask(completionHandler: { (profile , error) -> Void in
                    if profile != nil{
                        DispatchQueue.main.async(execute: { () -> Void in
                            let kakao : KOUser = profile as! KOUser
                            var nickName = ""
                            if let kakaoNickname = kakao.properties["nickname"] as? String{
                                nickName = kakaoNickname
                            }
                            self.login(String(describing: kakao.id), nickName: nickName, loginType: "k")
                        })
                    }else{
                        self.spin.isHidden = true
                        self.spin.stopAnimating()
                    }
                })
            }else{
                self.spin.isHidden = true
                self.spin.stopAnimating()
            }
        })
    }
    //페이스북 로그인 클릭
    func facebookAction(_ sender: AnyObject) {
        if spin.isHidden == false{
            return
        }
        spin.isHidden = false
        spin.startAnimating()
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile"], from: self, handler: { (result, error) in
            if error != nil{
                self.spin.isHidden = true
                self.spin.stopAnimating()
            } else if (result?.isCancelled)! {
                self.spin.isHidden = true
                self.spin.stopAnimating()
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if error != nil {
                        self.spin.isHidden = true
                        self.spin.stopAnimating()
                    } else {
                        var nickName = "", uid = ""
                        if let faceNickname = user?.displayName{
                            nickName = faceNickname
                        }
                        if let faceUid = user?.uid{
                            uid = faceUid
                        }
                        self.login(uid, nickName: nickName, loginType: "f")
                    }
                }
            }
        })
    }
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension LoginViewController{
    //뷰 클릭했을때
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? JoinViewController{
            vc.preIdField = self.idField
        }
    }
}
extension LoginViewController: UITextFieldDelegate{
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
