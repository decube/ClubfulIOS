//
//  AddView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 10. 4..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class AddView: UIView{
    static let radio_selectedImage = UIImage(named: "ic_select_on")
    static let radio_unselectedImage = UIImage(named: "ic_select_off")
    
    var ctrl : UIViewController!
    
    var userLatitude : Double!
    var userLongitude : Double!
    var userAddress : String!
    var userAddressShort : String!
    
    @IBOutlet var confirmBtn: UIButton!
    @IBOutlet var maleView: UIView!
    @IBOutlet var femaleView: UIView!
    @IBOutlet var maleImage: UIImageView!
    @IBOutlet var femaleImage: UIImageView!
    @IBOutlet var birth: UIDatePicker!
    @IBOutlet var locationBtn: UIButton!
    
    func setLayout(_ ctrl: UIViewController){
        self.ctrl = ctrl
        
        self.frame = CGRect(x: (ctrl.view.frame.width-300)/2, y: (ctrl.view.frame.height-300)/2, width: 300, height: 300)
        self.isHidden = true
        ctrl.view.addSubview(self)
        
        self.maleView.isUserInteractionEnabled = true
        self.maleView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.maleAction)))
        self.femaleView.isUserInteractionEnabled = true
        self.femaleView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.femaleAction)))
    }
    
    func maleAction(){
        self.maleImage.image = AddView.radio_selectedImage
        self.femaleImage.image = AddView.radio_unselectedImage
    }
    func femaleAction(){
        self.maleImage.image = AddView.radio_unselectedImage
        self.femaleImage.image = AddView.radio_selectedImage
    }
    func isSexString() -> String{
        if self.maleImage.image == AddView.radio_selectedImage{
            return "male"
        }else if self.femaleImage.image == AddView.radio_selectedImage{
            return "female"
        }else{
            return ""
        }
    }
    @IBAction func locationAction(_ sender: AnyObject) {
        if let vc = self.ctrl as? ViewController{
            vc.performSegue(withIdentifier: "main_map", sender: nil)
        }else if let vc = self.ctrl as? UserConvertViewController{
            vc.performSegue(withIdentifier: "userConvert_map", sender: nil)
        }
    }
    @IBAction func confirmAction(_ sender: AnyObject) {
        let user = Storage.getRealmUser()
        user.userLatitude = self.userLatitude
        user.userLongitude = self.userLongitude
        user.userAddress = self.userAddress
        user.userAddressShort = self.userAddressShort
        user.birth = self.birth.date
        user.sex = self.isSexString()
        Storage.setRealmUser(user)
        
        let param = ["userId":user.userId, "sex": user.sex, "birth": user.birth, "userLatitude": user.userLatitude, "userLongitude": user.userLongitude, "userAddress": user.userAddress, "userAddressShort": user.userAddressShort] as [String : Any]
        URLReq.request(ctrl, url: URLReq.apiServer+URLReq.api_user_info, param: param as [String : AnyObject])
        
        //애니메이션 적용
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            }, completion: {(_) in
                if let vo = self.ctrl as? ViewController{
                    vo.blackScreen.isHidden = true
                }else if let vo = self.ctrl as? UserConvertViewController{
                    vo.blackScreen.isHidden = true
                }
                self.isHidden = true
                self.alpha = 1
        })
    }
    
    func addViewShow(){
        self.ctrl.view.endEditing(true)
        
        
        let vo = Storage.getRealmUser()
        self.userLatitude = vo.userLatitude
        self.userLongitude = vo.userLongitude
        self.userAddress = vo.userAddress
        self.userAddressShort = vo.userAddressShort
        self.locationBtn.setTitle(vo.userAddressShort, for: .normal)
        self.birth.date = vo.birth
        if vo.sex == "male"{
            self.maleAction()
        }else if vo.sex == "female"{
            self.femaleAction()
        }
        
        
        
        if let vo = self.ctrl as? ViewController{
            vo.blackScreen.isHidden = false
        }else if let vo = self.ctrl as? UserConvertViewController{
            vo.blackScreen.isHidden = false
        }
        self.isHidden = false
        let tmpRect = self.frame
        self.frame.origin.y = -tmpRect.height
        //애니메이션 적용
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = tmpRect
        }, completion: {(_) in
            
        })
    }
    
    func addViewConfirm(){
        if Storage.isRealmUser(){
            //추가정보 확인
            let addInfoDate = Storage.getStorage("addInfo")
            var addViewIsShow = true
            if let date = addInfoDate as? Date{
                var saveDate = date
                let addDate = Date()
                saveDate.addTimeInterval(60*60*24)
                if saveDate.timeIntervalSince1970 > addDate.timeIntervalSince1970{
                    addViewIsShow = false
                }
            }
            if self.isHidden == true && addViewIsShow == true{
                Util.alert(ctrl, title: "알림", message: "더 정확하게 코트를 찾으시려면 추가정보를 입력하셔야 합니다.", confirmTitle: "입력할께요", cancelStr: "오늘 하루 안할께요", confirmHandler: { (_) in
                    self.addViewShow()
                    }, cancelHandler: { (_) in
                        Storage.setStorage("addInfo", value: Date() as AnyObject)
                })
            }
        }
    }
}
