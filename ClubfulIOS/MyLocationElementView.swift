//
//  MainCenterCellView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MyLocationElementView : UIView{
    @IBOutlet var addressShort: UIButton!
    @IBOutlet var address: UIButton!
    var ctrl: ViewController!
    var locationView: MyLocationView!
    var location: (Double, Double, String, String)!
    
    
    func setLayout(_ ctrl: ViewController, locationView: MyLocationView, height: CGFloat, idx: CGFloat, location: (Double, Double, String, String)){
        self.ctrl = ctrl
        self.locationView = locationView
        self.location = location
        self.frame = CGRect(x: 5, y: height*idx+5, width: self.frame.width-10, height: height-10)
        self.addressShort.setTitle(location.2, for: UIControlState())
        self.address.setTitle(location.3, for: UIControlState())
        locationView.scrollView.addSubview(self)
    }
    
    func setAction(){
        UIView.animate(withDuration: 0.2, animations: {
            self.locationView.alpha = 0
            }, completion: { (_) in
                self.locationView.isHidden = true
                self.locationView.alpha = 1
                self.ctrl.blackScreen.isHidden = true
                let deviceUser = Storage.getRealmDeviceUser()
                deviceUser.latitude = self.location.0
                deviceUser.longitude = self.location.1
                deviceUser.addressShort = "\(self.location.2)"
                deviceUser.address = "\(self.location.3)"
                Storage.setRealmDeviceUser(deviceUser)
        })
    }
    @IBAction func locationAction_1(_ sender: AnyObject) {
        setAction()
    }
    @IBAction func locationAction_2(_ sender: AnyObject) {
        setAction()
    }
}
