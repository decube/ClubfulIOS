//
//  UserConvertViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class UserConvertViewController: UIViewController {
    @IBOutlet var spin: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat = 0
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwdField: UITextField!
    @IBOutlet var newPwdField: UITextField!
    @IBOutlet var newRepwdField: UITextField!
    @IBOutlet var nicknameField: UITextField!
    
    var addView : AddView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        
        if let customView = Bundle.main.loadNibNamed("AddView", owner: self, options: nil)?.first as? AddView {
            self.addView = customView
            self.addView.setLayout(self)
        }
        
        spin.isHidden = true
        pwdField.delegate = self
        newPwdField.delegate = self
        newRepwdField.delegate = self
        nicknameField.delegate = self
        
        pwdField.maxLength(14)
        newPwdField.maxLength(14)
        newRepwdField.maxLength(14)
        nicknameField.maxLength(10)
        let user = Storage.getRealmUser()
        if user.loginType == "n"{
            idField.text = user.userId
        } else if user.loginType == "k"{
            idField.text = "카카오톡으로 로그인 된 아이디입니다."
        } else if user.loginType == "f"{
            idField.text = "페이스북으로 로그인 된 아이디입니다."
        }
        nicknameField.text = user.nickName
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                self.scrollViewHeight = self.scrollView.frame.height
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
            let user = Storage.getRealmUser()
            let deviceUser = Storage.getRealmDeviceUser()
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(user.userId as AnyObject, forKey: "userId")
            parameters.updateValue(self.pwdField.text! as AnyObject, forKey: "password")
            parameters.updateValue(self.newPwdField.text! as AnyObject, forKey: "newPassword")
            parameters.updateValue(deviceUser.pushID as AnyObject, forKey: "gcmId")
            parameters.updateValue(self.nicknameField.text! as AnyObject, forKey: "nickName")
            URLReq.request(self, url: URLReq.apiServer+URLReq.api_user_update, param: parameters, callback: { (dic) in
                var user = Storage.getRealmUser()
                user = Storage.getRealmUser()
                user.nickName = self.nicknameField.text!
                Storage.setRealmUser(user)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func addAction(_ sender: AnyObject) {
        self.addView.addViewShow()
    }
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension UserConvertViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapViewController{
            vc.preAddress = self.addView.address
            vc.preBtn = self.addView.locationBtn
        }
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
}
extension UserConvertViewController: UITextFieldDelegate{
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
    //뷰 클릭했을때
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
