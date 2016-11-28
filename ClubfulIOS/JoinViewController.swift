//
//  LoginViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController {
    @IBOutlet var spin: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat = 0
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwdField: UITextField!
    @IBOutlet var repwdField: UITextField!
    @IBOutlet var nicknameField: UITextField!
    
    var preIdField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        spin.isHidden = true
        idField.delegate = self
        pwdField.delegate = self
        repwdField.delegate = self
        nicknameField.delegate = self
        
        idField.maxLength(14)
        pwdField.maxLength(14)
        repwdField.maxLength(14)
        nicknameField.maxLength(10)
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                self.scrollViewHeight = self.scrollView.frame.height
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
            
            let deviceUser = Storage.getRealmDeviceUser()
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(self.idField.text! as AnyObject, forKey: "userId")
            parameters.updateValue(self.pwdField.text! as AnyObject, forKey: "password")
            parameters.updateValue(deviceUser.pushID as AnyObject, forKey: "gcmId")
            parameters.updateValue(self.nicknameField.text! as AnyObject, forKey: "nickName")
            parameters.updateValue(deviceUser.noticePushCheck as AnyObject, forKey: "noticePush")
            parameters.updateValue(deviceUser.myCourtPushCheck as AnyObject, forKey: "myInsertPush")
            parameters.updateValue(deviceUser.distancePushCheck as AnyObject, forKey: "distancePush")
            parameters.updateValue(deviceUser.interestPushCheck as AnyObject, forKey: "interestPush")
            parameters.updateValue(deviceUser.startPushTime.getTime() as AnyObject, forKey: "startTime")
            parameters.updateValue(deviceUser.endPushTime.getTime() as AnyObject, forKey: "endTime")
            
            URLReq.request(self, url: URLReq.apiServer+URLReq.api_user_join, param: parameters, callback: { (dic) in
                self.preIdField.text = self.idField.text!
                self.dismiss(animated: true, completion: nil)
            }, codeErrorCallback: { (dic) in
                self.spin.isHidden = true
                self.spin.stopAnimating()
            })
        }
    }
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension JoinViewController{
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    //view 사라지기 전 작동
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
}
extension JoinViewController: UITextFieldDelegate{
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
