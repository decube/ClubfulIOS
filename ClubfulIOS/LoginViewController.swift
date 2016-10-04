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
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


class LoginViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var spin: UIActivityIndicatorView!
    var vc : SetViewController!
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwField: UITextField!
    @IBOutlet var loginBtn: UIButton!
    @IBOutlet var joinBtn: UIButton!
    
    @IBOutlet var kakaoLogin: UIView!
    @IBOutlet var facebookLogin: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("LoginViewController viewDidLoad")
        
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
        if idField.text?.characters.count < 4{
            Util.alert(self, message: "아이디를 입력해 주세요.")
        }else if pwField.text?.characters.count < 6{
            Util.alert(self, message: "비밀번호를 입력해 주세요.")
        }else{
            let user = Storage.getRealmUser()
            self.spin.isHidden = false
            self.spin.startAnimating()
            let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "userId": self.idField.text! as AnyObject, "password": self.pwField.text! as AnyObject, "loginType": 1 as AnyObject]
            
            URL.request(self, url: URL.apiServer+URL.api_user_login, param: parameters, callback: { (dic) in
                self.loginCallback(1, dic: dic)
            }, codeErrorCallback: { (dic) in
                self.spin.isHidden = true
                self.spin.stopAnimating()
            })
        }
    }
    
    //로그인
    func login(_ userId: String, nickName: String, loginType: Int){
        let user = Storage.getRealmUser()
        var parameters : [String: AnyObject] = [:]
        parameters.updateValue(user.token as AnyObject, forKey: "token")
        parameters.updateValue(userId as AnyObject, forKey: "userId")
        parameters.updateValue("" as AnyObject, forKey: "password")
        parameters.updateValue(2 as AnyObject as AnyObject, forKey: "loginType")
        parameters.updateValue(user.gcmId as AnyObject, forKey: "gcmId")
        parameters.updateValue(nickName as AnyObject, forKey: "nickName")
        parameters.updateValue(user.noticePushCheck as AnyObject, forKey: "noticePush")
        parameters.updateValue(user.myCourtPushCheck as AnyObject, forKey: "myInsertPush")
        parameters.updateValue(user.distancePushCheck as AnyObject, forKey: "distancePush")
        parameters.updateValue(user.interestPushCheck as AnyObject, forKey: "interestPush")
        parameters.updateValue(user.startPushTime.getTime() as AnyObject, forKey: "startTime")
        parameters.updateValue(user.endPushTime.getTime() as AnyObject, forKey: "endTime")
        
        URL.request(self, url: URL.apiServer+URL.api_user_login, param: parameters, callback: { (dic) in
            self.loginCallback(loginType, dic: dic)
        }, codeErrorCallback: {(dic) in
            self.spin.isHidden = true
            self.spin.stopAnimating()
        })
    }
    
    func loginCallback(_ loginType: Int, dic: [String: AnyObject]){
        var user = Storage.getRealmUser()
        user = Storage.copyUser()
        user.isLogin = loginType
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
        
        
        user.noticePushCheck = dic["noticePush"] as! Bool
        user.myCourtPushCheck = dic["myCreateCourtPush"] as! Bool
        user.distancePushCheck = dic["distancePush"] as! Bool
        user.interestPushCheck = dic["interestPush"] as! Bool
        
        let dateMakerFormatter2 = DateFormatter()
        dateMakerFormatter2.calendar = Calendar.current
        dateMakerFormatter2.dateFormat = "hh:mm:ss"
        
        user.startPushTime = dateMakerFormatter2.date(from: "\(dic["startTime"] as! String)")!
        user.endPushTime = dateMakerFormatter2.date(from: "\(dic["endTime"] as! String)")!
        
        Storage.setRealmUser(user)
        self.vc.signCheck()
        self.spin.isHidden = true
        self.spin.stopAnimating()
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
                print(error?.localizedDescription)
            }else if session.isOpen() == true{
                KOSessionTask.meTask(completionHandler: { (profile , error) -> Void in
                    if profile != nil{
                        DispatchQueue.main.async(execute: { () -> Void in
                            let kakao : KOUser = profile as! KOUser
                            var nickName = ""
                            if let kakaoNickname = kakao.properties["nickname"] as? String{
                                nickName = kakaoNickname
                            }
                            self.login(String(describing: kakao.id), nickName: nickName, loginType: 2)
                        })
                    }else{
                        self.spin.isHidden = true
                        self.spin.stopAnimating()
                    }
                })
            }else{
                print("isNotOpen")
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
                print("Facebook login failed. Error \(error)")
                self.spin.isHidden = true
                self.spin.stopAnimating()
            } else if (result?.isCancelled)! {
                print("Facebook login isCancelled. result \(result?.token)")
                self.spin.isHidden = true
                self.spin.stopAnimating()
            } else {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                FIRAuth.auth()?.signIn(with: credential) { (user, error) in
                    if error != nil {
                        print("Login failed. \(error)")
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
                        self.login(uid, nickName: nickName, loginType: 3)
                    }
                }
            }
        })
    }
    
    
    
    
    //회원가입 클릭
    @IBAction func joinAction(_ sender: AnyObject) {
        if spin.isHidden == false{
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "joinVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        (uvc as! JoinViewController).loginVC = self
        self.present(uvc, animated: true, completion: nil)
    }
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
