//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire

class SettingViewController: UIViewController {
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
        print("SettingViewController viewDidLoad")
        
        noticeSwitch.on = realmUser.noticePushCheck
        myCourtSwitch.on = realmUser.myCourtPushCheck
        distanceSwitch.on = realmUser.distancePushCheck
        interestSwitch.on = realmUser.interestPushCheck
        
        startTime.date = realmUser.startPushTime
        endTime.date = realmUser.endPushTime
        
        switchFn()
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        let parameters : [String: AnyObject] = ["token": realmUser.token, "id": realmUser.userId, "startTime": startTime.date.getTime(), "endTime": endTime.date.getTime(), "noticePush": noticeSwitch.on, "myCreateCourtPush": myCourtSwitch.on, "distancePush": distanceSwitch.on, "interestPush": interestSwitch.on]
        Alamofire.request(.GET, URL.user_set, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data!
                let dic = Util.convertStringToDictionary(data)
                if let code = dic["code"] as? Int{
                    if code == 0{
                        let user = Storage.copyUser()
                        user.noticePushCheck = self.noticeSwitch.on
                        user.myCourtPushCheck = self.myCourtSwitch.on
                        user.distancePushCheck = self.distanceSwitch.on
                        user.interestPushCheck = self.interestSwitch.on
                        user.startPushTime = self.startTime.date
                        user.endPushTime = self.endTime.date
                        Storage.setRealmUser(user)
                        
                        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    }else{
                        if let isMsgView = dic["isMsgView"] as? Bool{
                            if isMsgView == true{
                                Util.alert(message: "\(dic["msg"]!)", ctrl: self)
                            }
                        }
                    }
                }
        }
    }
    
    @IBAction func noticeAction(sender: AnyObject) {
        switchFn()
    }
    @IBAction func myCourtAction(sender: AnyObject) {
        switchFn()
    }
    @IBAction func distanceAction(sender: AnyObject) {
        switchFn()
    }
    @IBAction func interestAction(sender: AnyObject) {
        switchFn()
    }
    
    func switchFn(){
        if noticeSwitch.on == false && myCourtSwitch.on == false && distanceSwitch.on == false && interestSwitch.on == false{
            startTime.hidden = true
            endTime.hidden = true
            timeAndLbl.hidden = true
        }else{
            startTime.hidden = false
            endTime.hidden = false
            timeAndLbl.hidden = false
        }
    }
    
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}


