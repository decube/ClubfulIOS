//
//  UserConvertViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import DLRadioButton

class UserConvertViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat!
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwdField: UITextField!
    @IBOutlet var newPwdField: UITextField!
    @IBOutlet var newRepwdField: UITextField!
    @IBOutlet var nicknameField: UITextField!
    @IBOutlet var convertBtn: UIButton!
    @IBOutlet var maleRadio: DLRadioButton!
    @IBOutlet var femaleRadio: DLRadioButton!
    @IBOutlet var birthDatePicker: UIDatePicker!
    @IBOutlet var locationBtn: UIButton!
    
    //위치 변수
    //위치 변수
    var latitude : Double!
    var longitude : Double!
    var address : String!
    var addressShort : String!
    
    
    //마이페이지 컨트롤러
    var mypageCtrl : MypageViewController!
    
    let user = Storage.getRealmUser()
    
    override func viewDidLoad() {
        print("UserConvertViewController viewDidLoad")
        
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
        if user.sex == "male"{
            maleRadio.selected = true
            femaleRadio.selected = false
        }else if user.sex == "femail"{
            maleRadio.selected = false
            femaleRadio.selected = true
        }
        birthDatePicker.date = user.birth
        self.latitude = user.userLatitude
        self.longitude = user.userLongitude
        self.address = user.userAddress
        self.addressShort = user.userAddressShort
    }
    
    //위치 클릭
    @IBAction func locationAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("mapVC")
        (uvc as! MapViewController).preView = self
        (uvc as! MapViewController).preBtn = locationBtn
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    
    
    //회원수정 클릭
    @IBAction func convertAction(sender: AnyObject) {
        if pwdField.text!.characters.count < 6{
            Util.alert(self, message: "비밀번호를 제대로 입력해주세요.")
        }else if newPwdField.text! != newRepwdField.text!{
            Util.alert(self, message: "새로운 비밀번호가 틀립니다.")
        }else if newPwdField.text!.characters.count != 0 && newPwdField.text!.characters.count < 6{
            Util.alert(self, message: "새로운 비밀번호는 6자리 이상 입력해 주세요.")
        }else if nicknameField.text!.characters.count < 2{
            Util.alert(self, message: "닉네임을 2자 이상 입력해 주세요.")
        }else{
            var sex = ""
            if maleRadio.selected == true{
                sex = "male"
            }else if femaleRadio.selected == true {
                sex = "female"
            }
            
            let birth = "\(birthDatePicker.date.year(birthDatePicker.calendar))-\(birthDatePicker.date.month(birthDatePicker.calendar))-\(birthDatePicker.date.day(birthDatePicker.calendar))"
            
            let parameters : [String: AnyObject] = ["token": user.token, "userId": user.userId, "password": self.pwdField.text!, "newPassword": self.newPwdField.text!, "gcmId": user.gcmId, "nickName": self.nicknameField.text!, "sex": sex, "birth": birth, "latitude": self.latitude, "longitude": self.longitude, "address": self.address, "addressShort": self.addressShort]
            URL.request(self, url: URL.apiServer+URL.api_user_update, param: parameters, callback: { (dic) in
                var user = Storage.getRealmUser()
                user = Storage.copyUser()
                user.userId = self.idField.text!
                user.nickName = self.nicknameField.text!
                user.sex = sex
                user.birth = self.birthDatePicker.date
                user.userLatitude = self.latitude
                user.userLongitude = self.longitude
                user.userAddress = self.address
                user.userAddressShort = self.addressShort
                Storage.setRealmUser(user)
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            })
        }
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
