//
//  UserConvertViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class UserConvertViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var spin: UIActivityIndicatorView!
    var mypageCtrl : MypageViewController!
    
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat = 0
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwdField: UITextField!
    @IBOutlet var newPwdField: UITextField!
    @IBOutlet var newRepwdField: UITextField!
    @IBOutlet var nicknameField: UITextField!
    
    let user = Storage.getRealmUser()
    
    @IBOutlet var backgroundImage: UIImageView!
    let background_landscape = UIImage(named: "background_landscape.png")
    let background_portrait = UIImage(named: "background_portrait.png")
    
    var isRotated = true
    
    var blackScreen = UIButton()
    var addView : AddView!
    
    //회전됬을때
    func rotated(){
        if(self.isRotated == false && UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
            self.isRotated = true
            self.view.endEditing(true)
            self.scrollViewHeight = self.scrollView.frame.height
            self.backgroundImage.image = self.background_portrait
            self.blackScreen.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.addView.frame = CGRect(x: (self.view.frame.width-300)/2, y: (self.view.frame.height-300)/2, width: 300, height: 300)
        }
        if(self.isRotated == true && UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
            self.isRotated = false
            self.view.endEditing(true)
            self.scrollViewHeight = self.scrollView.frame.height
            self.backgroundImage.image = self.background_landscape
            self.blackScreen.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            self.addView.frame = CGRect(x: (self.view.frame.width-300)/2, y: (self.view.frame.height-300)/2, width: 300, height: 300)
        }
    }
    
    
    override func viewDidLoad() {
        print("UserConvertViewController viewDidLoad")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        
        self.blackScreen.isHidden = true
        self.blackScreen.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        self.blackScreen.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.view.addSubview(self.blackScreen)
        if let customView = Bundle.main.loadNibNamed("AddView", owner: self, options: nil)?.first as? AddView {
            self.addView = customView
            self.addView.frame = CGRect(x: (self.view.frame.width-300)/2, y: (self.view.frame.height-300)/2, width: 300, height: 300)
            self.addView.isHidden = true
            self.view.addSubview(self.addView)
            self.addView.setLayout(ctrl: self, callback: { (_) in
                let vo = Storage.copyUser()
                vo.userLatitude = self.addView.userLatitude
                vo.userLongitude = self.addView.userLongitude
                vo.userAddress = self.addView.userAddress
                vo.userAddressShort = self.addView.userAddressShort
                vo.birth = self.addView.birth.date
                vo.sex = self.addView.isSexString()
                Storage.setRealmUser(vo)
                
                let param = ["token":vo.token, "userId":vo.userId, "sex": vo.sex, "birth": vo.birth, "userLatitude": vo.userLatitude, "userLongitude": vo.userLongitude, "userAddress": vo.userAddress, "userAddressShort": vo.userAddressShort] as [String : Any]
                URL.request(self, url: URL.apiServer+URL.api_user_info, param: param as [String : AnyObject])
                
                //애니메이션 적용
                UIView.animate(withDuration: 0.2, animations: {
                    self.addView.alpha = 0
                }, completion: {(_) in
                    self.blackScreen.isHidden = true
                    self.addView.isHidden = true
                    self.addView.alpha = 1
                })
            })
        }
        self.blackScreen.addAction(.touchUpInside) { (_) in
            let tmpRect = self.addView.frame
            //애니메이션 적용
            UIView.animate(withDuration: 0.2, animations: {
                self.addView.frame.origin.y = -tmpRect.height
            }, completion: {(_) in
                self.blackScreen.isHidden = true
                self.addView.isHidden = true
                self.addView.frame = tmpRect
            })
        }
        
        spin.isHidden = true
        idField.delegate = self
        pwdField.delegate = self
        newPwdField.delegate = self
        newRepwdField.delegate = self
        nicknameField.delegate = self
        
        idField.maxLength(14)
        pwdField.maxLength(14)
        newPwdField.maxLength(14)
        newRepwdField.maxLength(14)
        nicknameField.maxLength(10)
        
        scrollViewHeight = scrollView.frame.height
        
        
        if user.isLogin == 1{
            idField.text = user.userId
        } else if user.isLogin == 2{
            idField.text = "카카오톡으로 로그인 된 아이디입니다."
        } else if user.isLogin == 3{
            idField.text = "페이스북으로 로그인 된 아이디입니다."
        } else if user.isLogin == 4{
            idField.text = "네이버로 로그인 된 아이디입니다."
        }
        nicknameField.text = user.nickName
        
        if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
            self.backgroundImage.image = self.background_portrait
        }
        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
            self.backgroundImage.image = self.background_landscape
        }
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            if(UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
                self.isRotated = true
                self.scrollViewHeight = self.scrollView.frame.height
            }
            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
                self.isRotated = false
                self.scrollViewHeight = self.scrollView.contentSize.height
            }
        }
    }
    
    
    //회원수정 클릭
    @IBAction func convertAction(_ sender: AnyObject) {
        if pwdField.text!.characters.count < 6{
            Util.alert(self, message: "비밀번호를 제대로 입력해주세요.")
        }else if newPwdField.text! != newRepwdField.text!{
            Util.alert(self, message: "새로운 비밀번호가 틀립니다.")
        }else if newPwdField.text!.characters.count != 0 && newPwdField.text!.characters.count < 6{
            Util.alert(self, message: "새로운 비밀번호는 6자리 이상 입력해 주세요.")
        }else if nicknameField.text!.characters.count < 2{
            Util.alert(self, message: "닉네임을 2자 이상 입력해 주세요.")
        }else{
            spin.isHidden = false
            spin.startAnimating()
            let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "userId": user.userId as AnyObject, "password": self.pwdField.text! as AnyObject, "newPassword": self.newPwdField.text! as AnyObject, "gcmId": user.gcmId as AnyObject, "nickName": self.nicknameField.text! as AnyObject]
            URL.request(self, url: URL.apiServer+URL.api_user_update, param: parameters, callback: { (dic) in
                var user = Storage.getRealmUser()
                user = Storage.copyUser()
                user.nickName = self.nicknameField.text!
                Storage.setRealmUser(user)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
    @IBAction func addAction(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.addView.setView()
        
        self.blackScreen.isHidden = false
        self.addView.isHidden = false
        let tmpRect = self.addView.frame
        self.addView.frame.origin.y = -tmpRect.height
        //애니메이션 적용
        UIView.animate(withDuration: 0.2, animations: {
            self.addView.frame = tmpRect
        }, completion: {(_) in
            
        })
    }
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    //키보드 생김/사라짐 셀렉터
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //view 사라지기 전 작동
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    //키보드생길때
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize.height = self.scrollViewHeight+keyboardSize.height
        }
    }
    //키보드없어질때
    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentSize.height = self.scrollViewHeight
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
