//
//  AddView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 10. 4..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class AddView: UIView{
    static let radio_selectedImage = UIImage(named: "ic_radio_selected.jpg")
    static let radio_unselectedImage = UIImage(named: "ic_radio_unselected.jpg")
    
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
    
    func setView(){
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
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "mapVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        (uvc as! MapViewController).preView = self.ctrl
        (uvc as! MapViewController).preBtn = self.locationBtn
        ctrl.present(uvc, animated: true, completion: nil)
    }
    @IBAction func confirmAction(_ sender: AnyObject) {
        let vo = Storage.copyUser()
        vo.userLatitude = self.userLatitude
        vo.userLongitude = self.userLongitude
        vo.userAddress = self.userAddress
        vo.userAddressShort = self.userAddressShort
        vo.birth = self.birth.date
        vo.sex = self.isSexString()
        Storage.setRealmUser(vo)
        
        let param = ["token":vo.token, "userId":vo.userId, "sex": vo.sex, "birth": vo.birth, "userLatitude": vo.userLatitude, "userLongitude": vo.userLongitude, "userAddress": vo.userAddress, "userAddressShort": vo.userAddressShort] as [String : Any]
        URL.request(ctrl, url: URL.apiServer+URL.api_user_info, param: param as [String : AnyObject])
        
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
}
