//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import InputTag

class JoinViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat!
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwdField: UITextField!
    @IBOutlet var repwdField: UITextField!
    @IBOutlet var nicknameField: UITextField!
    @IBOutlet var joinBtn: UIButton!
    var maleRadio: Radio!
    var femaleRadio: Radio!
    @IBOutlet var maleLbl: UILabel!
    @IBOutlet var femaleLbl: UILabel!
    @IBOutlet var locationBtn: UIButton!
    
    //위치 변수
    //위치 변수
    var latitude : Double!
    var longitude : Double!
    
    override func viewDidLoad() {
        print("JoinViewController viewDidLoad")
        
        idField.delegate = self
        pwdField.delegate = self
        repwdField.delegate = self
        nicknameField.delegate = self
        
        idField.maxLength(14)
        pwdField.maxLength(14)
        repwdField.maxLength(14)
        nicknameField.maxLength(10)
        
        var maleRadioFrame = maleLbl.frame
        var femaleRadioFrame = femaleLbl.frame
        maleRadioFrame.origin.x = maleRadioFrame.origin.x+maleRadioFrame.width + 10
        femaleRadioFrame.origin.x = femaleRadioFrame.origin.x+femaleRadioFrame.width + 10
        maleRadio = InputTag().getRadio(maleRadioFrame, name: "sex", value: "male", selected: true)
        femaleRadio = InputTag().getRadio(femaleRadioFrame, name: "sex", value: "female")
        InputTag.radioAdd(maleRadio)
        InputTag.radioAdd(femaleRadio)
        
        scrollView.addSubview(maleRadio)
        scrollView.addSubview(femaleRadio)
        
        locationBtn.boxLayout(radius: 6)
        
        scrollViewHeight = scrollView.frame.height
    }
    
    //위치 클릭
    @IBAction func locationAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("joinMapVC")
        (uvc as! JoinMapViewController).joinView = self
        (uvc as! JoinMapViewController).joinLocationBtn = locationBtn
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    //회원가입 클릭
    @IBAction func joinAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //키보드 생김/사라짐 셀렉터
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    //view 사라지기 전 작동
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //키보드생길때
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollViewHeight+keyboardSize.height)
        }
    }
    //키보드없어질때
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollViewHeight)
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


