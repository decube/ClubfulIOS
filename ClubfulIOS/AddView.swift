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
    
    var address: Address!
    
    @IBOutlet var maleView: UIView!
    @IBOutlet var femaleView: UIView!
    @IBOutlet var maleImage: UIImageView!
    @IBOutlet var femaleImage: UIImageView!
    @IBOutlet var birth: UIDatePicker!
    @IBOutlet var locationBtn: UIButton!
    
    var keyboardHideCallback: ((Void) -> Void)!
    var alertCallback: ((UIAlertController) -> Void)!
    var mapMoveCallback: ((Void) -> Void)!
    
    override func awakeFromNib() {
        self.address = Address()
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
        if self.mapMoveCallback != nil{
            self.mapMoveCallback()
        }
    }
    @IBAction func confirmAction(_ sender: AnyObject) {
        let user = Storage.getRealmUser()
        user.userLatitude = self.address.latitude
        user.userLongitude = self.address.longitude
        user.userAddress = self.address.address
        user.userAddressShort = self.address.addressShort
        user.birth = self.birth.date
        user.sex = self.isSexString()
        Storage.setRealmUser(user)
        
        var parameters : [String: AnyObject] = [:]
        parameters.updateValue(user.userId as AnyObject, forKey: "userId")
        parameters.updateValue(user.sex as AnyObject, forKey: "sex")
        parameters.updateValue(user.birth as AnyObject, forKey: "birth")
        parameters.updateValue(user.userLatitude as AnyObject, forKey: "userLatitude")
        parameters.updateValue(user.userLongitude as AnyObject, forKey: "userLongitude")
        parameters.updateValue(user.userAddress as AnyObject, forKey: "userAddress")
        parameters.updateValue(user.userAddressShort as AnyObject, forKey: "userAddressShort")
        URLReq.request(url: URLReq.apiServer+"user/info", param: parameters)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            }, completion: {(_) in
                self.isHidden = true
                self.alpha = 1
        })
    }
    
    func addViewShow(){
        if self.keyboardHideCallback != nil{
            self.keyboardHideCallback()
        }
        let vo = Storage.getRealmUser()
        self.address.latitude = vo.userLatitude
        self.address.longitude = vo.userLongitude
        self.address.address = vo.userAddress
        self.address.addressShort = vo.userAddressShort
        self.locationBtn.setTitle(vo.userAddressShort, for: .normal)
        self.birth.date = vo.birth
        if vo.sex == "male"{
            self.maleAction()
        }else if vo.sex == "female"{
            self.femaleAction()
        }
        self.isHidden = false
        let tmpRect = self.frame
        self.frame.origin.y = -tmpRect.height
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = tmpRect
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
                let alert = Util.alert(title: "알림", message: "더 정확하게 코트를 찾으시려면 추가정보를 입력하셔야 합니다.", confirmTitle: "입력할께요", cancelStr: "오늘 하루 안할께요", isCancel: true, confirmHandler: { (_) in
                    self.addViewShow()
                    }, cancelHandler: { (_) in
                        Storage.setStorage("addInfo", value: Date() as AnyObject)
                })
                if self.alertCallback != nil{
                    self.alertCallback(alert)
                }
            }
        }
    }
}
