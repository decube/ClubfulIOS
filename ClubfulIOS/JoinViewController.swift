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
    var scrollViewHeight : CGFloat!
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwdField: UITextField!
    @IBOutlet var repwdField: UITextField!
    @IBOutlet var nicknameField: UITextField!
    @IBOutlet var joinBtn: UIButton!
    @IBOutlet var birthDatePicker: UIDatePicker!
    @IBOutlet var locationBtn: UIButton!
    
    @IBOutlet var maleRadio: UIView!
    @IBOutlet var femaleRadio: UIView!
    @IBOutlet var maleImage: UIImageView!
    @IBOutlet var femaleImage: UIImageView!
    let radioSelect = UIImage(named: "ic_radio_selected.jpg")
    let radioUnselect = UIImage(named: "ic_radio_unselected.jpg")
    
    //위치 변수
    //위치 변수
    var latitude : Double!
    var longitude : Double!
    var address : String!
    var addressShort : String!
    
    var user = Storage.getRealmUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("JoinViewController viewDidLoad")
        
        spin.hidden = true
        idField.delegate = self
        pwdField.delegate = self
        repwdField.delegate = self
        nicknameField.delegate = self
        
        idField.maxLength(14)
        pwdField.maxLength(14)
        repwdField.maxLength(14)
        nicknameField.maxLength(10)
        
        maleImage.image = self.radioUnselect
        femaleImage.image = self.radioUnselect
        
        scrollViewHeight = scrollView.frame.height
        
        maleRadio.userInteractionEnabled = true
        femaleRadio.userInteractionEnabled = true
        maleRadio.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.maleAction)))
        femaleRadio.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.femaleAction)))
    }
    
    func maleAction(){
        maleImage.image = self.radioSelect
        femaleImage.image = self.radioUnselect
    }
    func femaleAction(){
        maleImage.image = self.radioUnselect
        femaleImage.image = self.radioSelect
    }
    
    //위치 클릭
    @IBAction func locationAction(sender: AnyObject) {
        if spin.hidden == false{
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("mapVC")
        (uvc as! MapViewController).preView = self
        (uvc as! MapViewController).preBtn = locationBtn
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    //회원가입 클릭
    @IBAction func joinAction(sender: AnyObject) {
        if spin.hidden == false{
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
        }else if latitude == nil || longitude == nil || address == nil || addressShort == nil{
            Util.alert(self, message: "위치설정을 해주세요.")
        }else{
            var sex = ""
            if maleImage.image == self.radioSelect{
                sex = "male"
            }else if femaleImage.image == self.radioSelect{
                sex = "female"
            }
            
            spin.hidden = false
            spin.startAnimating()
            let parameters : [String: AnyObject] = ["token": user.token, "userId": self.idField.text!, "password": self.pwdField.text!, "gcmId": user.gcmId, "nickName": self.nicknameField.text!, "sex": sex, "birth": birthDatePicker.date.getDate(), "userLatitude": self.latitude, "userLongitude": self.longitude, "userAddress": self.address, "userAddressShort": self.addressShort, "noticePush": user.noticePushCheck, "myInsertPush": user.myCourtPushCheck, "distancePush": user.distancePushCheck, "interestPush": user.interestPushCheck, "startTime": user.startPushTime.getTime(), "endTime": user.endPushTime.getTime()]
            
            URL.request(self, url: URL.apiServer+URL.api_user_join, param: parameters, callback: { (dic) in
                self.loginVC.idField.text = self.idField.text!
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }, codeErrorCallback: { (dic) in
                self.spin.hidden = true
                self.spin.stopAnimating()
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
