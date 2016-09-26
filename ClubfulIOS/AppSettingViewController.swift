//
//  AppSetting.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class AppSettingViewController : UIViewController{
    @IBOutlet var noticeSwitch: UISwitch!
    @IBOutlet var myCourtSwitch: UISwitch!
    @IBOutlet var distanceSwitch: UISwitch!
    @IBOutlet var interestSwitch: UISwitch!
    
    @IBOutlet var startTime: UIDatePicker!
    @IBOutlet var endTime: UIDatePicker!
    @IBOutlet var timeAndLbl: UILabel!
    
    @IBOutlet var saveBtn: UIButton!
    
    var realmUser = Storage.getRealmUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("AppSettingViewController viewDidLoad")
        
        noticeSwitch.isOn = realmUser.noticePushCheck
        myCourtSwitch.isOn = realmUser.myCourtPushCheck
        distanceSwitch.isOn = realmUser.distancePushCheck
        interestSwitch.isOn = realmUser.interestPushCheck
        
        startTime.date = realmUser.startPushTime as Date
        endTime.date = realmUser.endPushTime as Date
        
        switchFn()
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        let parameters : [String: AnyObject] = ["token": realmUser.token as AnyObject, "id": realmUser.userId as AnyObject, "startTime": startTime.date.getTime() as AnyObject, "endTime": endTime.date.getTime() as AnyObject, "noticePush": noticeSwitch.isOn as AnyObject, "myCreateCourtPush": myCourtSwitch.isOn as AnyObject, "distancePush": distanceSwitch.isOn as AnyObject, "interestPush": interestSwitch.isOn as AnyObject]
        
        URL.request(self, url: URL.apiServer+URL.api_user_set, param: parameters, callback: { (dic) in
            let user = Storage.copyUser()
            user.noticePushCheck = self.noticeSwitch.isOn
            user.myCourtPushCheck = self.myCourtSwitch.isOn
            user.distancePushCheck = self.distanceSwitch.isOn
            user.interestPushCheck = self.interestSwitch.isOn
            user.startPushTime = self.startTime.date
            user.endPushTime = self.endTime.date
            Storage.setRealmUser(user)
            
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        })
    }
    
    @IBAction func noticeAction(_ sender: AnyObject) {
        switchFn()
    }
    @IBAction func myCourtAction(_ sender: AnyObject) {
        switchFn()
    }
    @IBAction func distanceAction(_ sender: AnyObject) {
        switchFn()
    }
    @IBAction func interestAction(_ sender: AnyObject) {
        switchFn()
    }
    
    func switchFn(){
        if noticeSwitch.isOn == false && myCourtSwitch.isOn == false && distanceSwitch.isOn == false && interestSwitch.isOn == false{
            startTime.isHidden = true
            endTime.isHidden = true
            timeAndLbl.isHidden = true
        }else{
            startTime.isHidden = false
            endTime.isHidden = false
            timeAndLbl.isHidden = false
        }
    }
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
