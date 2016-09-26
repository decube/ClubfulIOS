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
        
        spin.isHidden = true
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
        if spin.isHidden == false{
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "mapVC")
        (uvc as! MapViewController).preView = self
        (uvc as! MapViewController).preBtn = locationBtn
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
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
        }else if latitude == nil || longitude == nil || address == nil || addressShort == nil{
            Util.alert(self, message: "위치설정을 해주세요.")
        }else{
            var sex = ""
            if maleImage.image == self.radioSelect{
                sex = "male"
            }else if femaleImage.image == self.radioSelect{
                sex = "female"
            }
            
            spin.isHidden = false
            spin.startAnimating()
            
            let user = Storage.getRealmUser()
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(user.token as AnyObject, forKey: "token")
            parameters.updateValue(self.idField.text! as AnyObject, forKey: "userId")
            parameters.updateValue(self.pwdField.text! as AnyObject, forKey: "password")
            parameters.updateValue(user.gcmId as AnyObject, forKey: "gcmId")
            parameters.updateValue(self.nicknameField.text! as AnyObject, forKey: "nickName")
            parameters.updateValue(sex as AnyObject, forKey: "sex")
            parameters.updateValue(birthDatePicker.date.getDate() as AnyObject, forKey: "birth")
            parameters.updateValue(self.latitude as AnyObject, forKey: "userLatitude")
            parameters.updateValue(self.longitude as AnyObject, forKey: "userLongitude")
            parameters.updateValue(self.address as AnyObject, forKey: "userAddress")
            parameters.updateValue(addressShort as AnyObject, forKey: "userAddressShort")
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
