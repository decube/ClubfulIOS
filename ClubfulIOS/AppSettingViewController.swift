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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        let deviceUser = Storage.getRealmDeviceUser()
        noticeSwitch.setYN(deviceUser.noticePushCheck)
        myCourtSwitch.setYN(deviceUser.myCourtPushCheck)
        distanceSwitch.setYN(deviceUser.distancePushCheck)
        interestSwitch.setYN(deviceUser.interestPushCheck)
        
        startTime.date = deviceUser.startPushTime as Date
        endTime.date = deviceUser.endPushTime as Date
        
        self.switchFn()
    }
    
    @IBAction func saveAction(_ sender: AnyObject) {
        let user = Storage.getRealmUser()
        let deviceUser = Storage.getRealmDeviceUser()
        var parameters : [String: AnyObject] = [:]
        parameters.updateValue(user.userId as AnyObject, forKey: "id")
        parameters.updateValue(startTime.date.getTime() as AnyObject, forKey: "startTime")
        parameters.updateValue(endTime.date.getTime() as AnyObject, forKey: "endTime")
        parameters.updateValue(noticeSwitch.getYN() as AnyObject, forKey: "noticePush")
        parameters.updateValue(myCourtSwitch.getYN() as AnyObject, forKey: "myCreateCourtPush")
        parameters.updateValue(distanceSwitch.getYN() as AnyObject, forKey: "distancePush")
        parameters.updateValue(interestSwitch.getYN() as AnyObject, forKey: "interestPush")
        
        URLReq.request(self, url: URLReq.apiServer+"user/set", param: parameters, callback: { (dic) in
            deviceUser.noticePushCheck = self.noticeSwitch.getYN()
            deviceUser.myCourtPushCheck = self.myCourtSwitch.getYN()
            deviceUser.distancePushCheck = self.distanceSwitch.getYN()
            deviceUser.interestPushCheck = self.interestSwitch.getYN()
            deviceUser.startPushTime = self.startTime.date
            deviceUser.endPushTime = self.endTime.date
            Storage.setRealmDeviceUser(deviceUser)
            
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
    
    //제스처
    var interactor:Interactor? = nil
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: view.bounds, direction: .right)
        MenuHelper.mapGestureStateToInteractor(sender.state,progress: progress,interactor: interactor){
            self.dismiss(animated: true, completion: nil)
        }
    }
}
