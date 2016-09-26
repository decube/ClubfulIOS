//
//  UserConvertViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class UserConvertViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat!
    @IBOutlet var idField: UITextField!
    @IBOutlet var pwdField: UITextField!
    @IBOutlet var newPwdField: UITextField!
    @IBOutlet var newRepwdField: UITextField!
    @IBOutlet var nicknameField: UITextField!
    @IBOutlet var convertBtn: UIButton!
    @IBOutlet var maleRadio: UIView!
    @IBOutlet var femaleRadio: UIView!
    @IBOutlet var maleImage: UIImageView!
    @IBOutlet var femaleImage: UIImageView!
    let radioSelect = UIImage(named: "ic_radio_selected.jpg")
    let radioUnselect = UIImage(named: "ic_radio_unselected.jpg")
    
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
            maleImage.image = self.radioSelect
            femaleImage.image = self.radioUnselect
        }else if user.sex == "femail"{
            maleImage.image = self.radioUnselect
            femaleImage.image = self.radioSelect
        }else{
            maleImage.image = self.radioUnselect
            femaleImage.image = self.radioUnselect
        }
        birthDatePicker.date = user.birth as Date
        self.latitude = user.userLatitude
        self.longitude = user.userLongitude
        self.address = user.userAddress
        self.addressShort = user.userAddressShort
        
        maleRadio.isUserInteractionEnabled = true
        femaleRadio.isUserInteractionEnabled = true
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
    @IBAction func locationAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "mapVC")
        (uvc as! MapViewController).preView = self
        (uvc as! MapViewController).preBtn = locationBtn
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
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
            var sex = ""
            if maleImage.image == self.radioSelect{
                sex = "male"
            }else if femaleImage.image == self.radioSelect{
                sex = "female"
            }
            
            let birth = "\(birthDatePicker.date.year(birthDatePicker.calendar))-\(birthDatePicker.date.month(birthDatePicker.calendar))-\(birthDatePicker.date.day(birthDatePicker.calendar))"
            
            let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "userId": user.userId as AnyObject, "password": self.pwdField.text! as AnyObject, "newPassword": self.newPwdField.text! as AnyObject, "gcmId": user.gcmId as AnyObject, "nickName": self.nicknameField.text! as AnyObject, "sex": sex as AnyObject, "birth": birth as AnyObject, "latitude": self.latitude as AnyObject, "longitude": self.longitude as AnyObject, "address": self.address as AnyObject, "addressShort": self.addressShort as AnyObject]
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
                self.presentingViewController?.dismiss(animated: true, completion: nil)
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
    //view 사라지기 전 작동
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    //키보드생길때
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollViewHeight+keyboardSize.height)
        }
    }
    //키보드없어질때
    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: scrollViewHeight)
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
