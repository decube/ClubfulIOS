//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class JoinViewController: UIViewController, UITextFieldDelegate {
    
    override func viewDidLoad() {
        print("JoinViewController viewDidLoad")
        
        let loginField = UITextField(frame: CGRect(x: 20, y: 100, width: Util.screenSize.width-40, height: 40), placeholder: "아이디를 입력해주세요.", textAlignment: .Left, delegate: self)
        let pwdField = UITextField(frame: CGRect(x: 20, y: 150, width: Util.screenSize.width-40, height: 40), placeholder: "비밀번호를 입력해주세요.", textAlignment: .Left, delegate: self)
        let repwdField = UITextField(frame: CGRect(x: 20, y: 200, width: Util.screenSize.width-40, height: 40), placeholder: "비밀번호를 다시 입력해주세요.", textAlignment: .Left, delegate: self)
        let nicknameField = UITextField(frame: CGRect(x: 20, y: 250, width: Util.screenSize.width-40, height: 40), placeholder: "닉네임을 입력해주세요.", textAlignment: .Left, delegate: self)
        
        pwdField.secureTextEntry = true
        repwdField.secureTextEntry = true
        loginField.maxLength(14)
        pwdField.maxLength(14)
        repwdField.maxLength(14)
        nicknameField.maxLength(10)
        loginField.returnKeyType = UIReturnKeyType.Done
        pwdField.returnKeyType = UIReturnKeyType.Done
        repwdField.returnKeyType = UIReturnKeyType.Done
        nicknameField.returnKeyType = UIReturnKeyType.Done
        
        
        let joinBtn = UIButton(frame: CGRect(x: 10, y: Util.screenSize.height-60, width: Util.screenSize.width-20, height: 40), text: "회원가입", fontSize: 17)
        
        joinBtn.boxLayout(radius: 6, backgroundColor: Util.commonColor)
        
        self.view.addSubview(loginField)
        self.view.addSubview(pwdField)
        self.view.addSubview(repwdField)
        self.view.addSubview(nicknameField)
        
        
        self.view.addSubview(joinBtn)
        
        CustomView.initLayout(self, title: "회원가입")
    }
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


