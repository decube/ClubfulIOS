//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    @IBOutlet var noticeSwitch: UISwitch!
    @IBOutlet var myCourtSwitch: UISwitch!
    @IBOutlet var distanceSwitch: UISwitch!
    @IBOutlet var interestSwitch: UISwitch!
    
    @IBOutlet var startTime: UIDatePicker!
    @IBOutlet var endTime: UIDatePicker!
    @IBOutlet var timeAndLbl: UILabel!
    
    @IBOutlet var saveBtn: UIButton!
    override func viewDidLoad() {
        print("SettingViewController viewDidLoad")
        
        let realmUser = Storage.getRealmUser()
        noticeSwitch.on = realmUser.noticePushCheck
        myCourtSwitch.on = realmUser.myCourtPushCheck
        distanceSwitch.on = realmUser.distancePushCheck
        interestSwitch.on = realmUser.starPushCheck
        
        startTime.date = realmUser.startPushTime
        endTime.date = realmUser.endPushTime
        
        switchFn()
    }
    
    @IBAction func saveAction(sender: AnyObject) {
        let user = Storage.copyUser()
        user.noticePushCheck = noticeSwitch.on
        user.myCourtPushCheck = myCourtSwitch.on
        user.distancePushCheck = distanceSwitch.on
        user.starPushCheck = interestSwitch.on
        user.startPushTime = startTime.date
        user.endPushTime = endTime.date
        Storage.setRealmUser(user)
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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


