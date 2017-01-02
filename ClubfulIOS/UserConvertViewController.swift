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
    
    var addView : AddView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        
        self.addView = Bundle.main.loadNibNamed("AddView", owner: self, options: nil)?.first as? AddView
        self.addView?.delegate = self
        self.addView?.load()
        
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
            idField.text = "카카오톡으로 로그인 된 회원입니다."
            pwdField.isEnabled = false
            newPwdField.isEnabled = false
            newRepwdField.isEnabled = false
            pwdField.placeholder = "카카오톡으로 로그인 된 회원입니다."
            newPwdField.placeholder = "카카오톡으로 로그인 된 회원입니다."
            newRepwdField.placeholder = "카카오톡으로 로그인 된 회원입니다."
        } else if user.loginType == "f"{
            idField.text = "페이스북으로 로그인 된 회원입니다."
            pwdField.isEnabled = false
            newPwdField.isEnabled = false
            newRepwdField.isEnabled = false
            pwdField.placeholder = "페이스북으로 로그인 된 회원입니다."
            newPwdField.placeholder = "페이스북으로 로그인 된 회원입니다."
            newRepwdField.placeholder = "페이스북으로 로그인 된 회원입니다."
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
        let user = Storage.getRealmUser()
        if user.loginType == "n" && pwdField.text!.characters.count < 6{
            _ = Util.alert(self, message: "비밀번호를 제대로 입력해주세요.")
        }else if user.loginType == "n" && newPwdField.text! != newRepwdField.text!{
            _ = Util.alert(self, message: "새로운 비밀번호가 틀립니다.")
        }else if user.loginType == "n" && newPwdField.text!.characters.count != 0 && newPwdField.text!.characters.count < 6{
            _ = Util.alert(self, message: "새로운 비밀번호는 6자리 이상 입력해 주세요.")
        }else if nicknameField.text!.characters.count < 2{
            _ = Util.alert(self, message: "닉네임을 2자 이상 입력해 주세요.")
        }else{
            spin.isHidden = false
            spin.startAnimating()
            let deviceUser = Storage.getRealmDeviceUser()
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(user.userId as AnyObject, forKey: "userId")
            parameters.updateValue(self.pwdField.text! as AnyObject, forKey: "password")
            parameters.updateValue(self.newPwdField.text! as AnyObject, forKey: "newPassword")
            parameters.updateValue(deviceUser.pushID as AnyObject, forKey: "gcmId")
            parameters.updateValue(self.nicknameField.text! as AnyObject, forKey: "nickName")
            URLReq.request(self, url: URLReq.apiServer+"user/update", param: parameters, callback: { (dic) in
                var user = Storage.getRealmUser()
                user = Storage.getRealmUser()
                user.nickName = self.nicknameField.text!
                Storage.setRealmUser(user)
                self.presentingViewController?.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func addAction(_ sender: AnyObject) {
        self.addView?.addViewShow()
    }
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension UserConvertViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MapViewController{
            vc.returnCallback = {(address: Address) in
                self.addView?.address = address
                self.addView?.locationBtn.setTitle("\(address.addressShort!)", for: UIControlState())
            }
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
extension UserConvertViewController: AddViewDelegate{
    func addViewKeyboardHide() {
        self.view.endEditing(true)
    }
    func addViewMapMove() {
        self.performSegue(withIdentifier: "userConvert_map", sender: nil)
    }
    func addViewAlert(_ alert: UIAlertController) {
        self.present(alert, animated: false, completion: {(_) in })
    }
    func addViewLoad() {
        self.addView?.frame = self.view.frame
        self.view.addSubview(self.addView!)
    }
}
