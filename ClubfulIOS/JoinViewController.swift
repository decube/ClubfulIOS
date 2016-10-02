//
//  LoginViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var spin: UIActivityIndicatorView!
    var loginVC : LoginViewController!
    
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat = 0
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwdField: UITextField!
    @IBOutlet var repwdField: UITextField!
    @IBOutlet var nicknameField: UITextField!
    
    var user = Storage.getRealmUser()
    
    @IBOutlet var backgroundImage: UIImageView!
    let background_landscape = UIImage(named: "background_landscape.png")
    let background_portrait = UIImage(named: "background_portrait.png")
    
    var isRotated = true
    //회전됬을때
    func rotated(){
        if(self.isRotated == false && UIDeviceOrientationIsPortrait(UIDevice.current.orientation)){
            self.isRotated = true
            self.view.endEditing(true)
            self.scrollViewHeight = self.scrollView.frame.height
            self.backgroundImage.image = self.background_portrait
        }
        if(self.isRotated == true && UIDeviceOrientationIsLandscape(UIDevice.current.orientation)){
            self.isRotated = false
            self.view.endEditing(true)
            self.scrollViewHeight = self.scrollView.frame.height
            self.backgroundImage.image = self.background_landscape
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("JoinViewController viewDidLoad")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        spin.isHidden = true
        idField.delegate = self
        pwdField.delegate = self
        repwdField.delegate = self
        nicknameField.delegate = self
        
        idField.maxLength(14)
        pwdField.maxLength(14)
        repwdField.maxLength(14)
        nicknameField.maxLength(10)
        
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
    
    
    //회원가입 클릭
    @IBAction func joinAction(_ sender: AnyObject) {
        if spin.isHidden == false{
            return
        }
        if idField.text!.characters.count < 6{
            Util.alert(self, message: "아이디를 제대로 입력해주세요.")
        }else if pwdField.text!.characters.count < 6{
            Util.alert(self, message: "비밀번호를 제대로 입력해주세요.")
        }else if pwdField.text! != repwdField.text!{
            Util.alert(self, message: "비밀번호가 틀립니다.")
        }else if nicknameField.text!.characters.count < 2{
            Util.alert(self, message: "닉네임을 2자 이상 입력해 주세요.")
        }else{
            
            spin.isHidden = false
            spin.startAnimating()
            
            let user = Storage.getRealmUser()
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(user.token as AnyObject, forKey: "token")
            parameters.updateValue(self.idField.text! as AnyObject, forKey: "userId")
            parameters.updateValue(self.pwdField.text! as AnyObject, forKey: "password")
            parameters.updateValue(user.gcmId as AnyObject, forKey: "gcmId")
            parameters.updateValue(self.nicknameField.text! as AnyObject, forKey: "nickName")
            parameters.updateValue(user.noticePushCheck as AnyObject, forKey: "noticePush")
            parameters.updateValue(user.myCourtPushCheck as AnyObject, forKey: "myInsertPush")
            parameters.updateValue(user.distancePushCheck as AnyObject, forKey: "distancePush")
            parameters.updateValue(user.interestPushCheck as AnyObject, forKey: "interestPush")
            parameters.updateValue(user.startPushTime.getTime() as AnyObject, forKey: "startTime")
            parameters.updateValue(user.endPushTime.getTime() as AnyObject, forKey: "endTime")
            
            URL.request(self, url: URL.apiServer+URL.api_user_join, param: parameters, callback: { (dic) in
                self.loginVC.idField.text = self.idField.text!
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            }, codeErrorCallback: { (dic) in
                self.spin.isHidden = true
                self.spin.stopAnimating()
            })
        }
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
    
    //view 사라지기 전 작동
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
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
