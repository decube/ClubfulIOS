//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    override func viewDidLoad() {
        print("SettingViewController viewDidLoad")
        
        //ajax통신
        //통신 없으면 저장소
        let realmUser = Storage.getRealmUser()
        
        let noticePushView = UIView(frame: CGRect(x: 20, y: 110, width: Util.screenSize.width-20, height: 40))
        let myCourtPushView = UIView(frame: CGRect(x: 20, y: 160, width: Util.screenSize.width-20, height: 40))
        let distanceCourtPushView = UIView(frame: CGRect(x: 20, y: 210, width: Util.screenSize.width-20, height: 40))
        let goodCourtPushView = UIView(frame: CGRect(x: 20, y: 260, width: Util.screenSize.width-20, height: 40))
        
        let noticePushLbl = UILabel(frame: CGRect(x: 0, y: 0, width: noticePushView.frame.width-60, height: noticePushView.frame.height), text: "공지알림 받기", textAlignment: .Left, fontSize: 17)
        let myCourtPushLbl = UILabel(frame: CGRect(x: 0, y: 0, width: myCourtPushView.frame.width-60, height: myCourtPushView.frame.height), text: "내가 등록한 코드댓글 알림 받기", textAlignment: .Left, fontSize: 17)
        let distanceCourtPushLbl = UILabel(frame: CGRect(x: 0, y: 0, width: distanceCourtPushView.frame.width-60, height: distanceCourtPushView.frame.height), text: "근처장소 알림 받기", textAlignment: .Left, fontSize: 17)
        let goodCourtPushLbl = UILabel(frame: CGRect(x: 0, y: 0, width: goodCourtPushView.frame.width-60, height: goodCourtPushView.frame.height), text: "관심장소 알림 받기", textAlignment: .Left, fontSize: 17)
        
        let noticePushSwitch = UISwitch(frame: CGRect(x: 10+noticePushLbl.intrinsicContentSize().width, y: 0, width: 50, height: noticePushView.frame.height))
        let myCourtPushSwitch = UISwitch(frame: CGRect(x: 10+myCourtPushLbl.intrinsicContentSize().width, y: 0, width: 50, height: myCourtPushView.frame.height))
        let distanceCourtPushSwitch = UISwitch(frame: CGRect(x: 10+distanceCourtPushLbl.intrinsicContentSize().width, y: 0, width: 50, height: distanceCourtPushView.frame.height))
        let goodCourtPushSwitch = UISwitch(frame: CGRect(x: 10+goodCourtPushLbl.intrinsicContentSize().width, y: 0, width: 50, height: goodCourtPushView.frame.height))
        
        noticePushSwitch.on = realmUser.noticePushCheck
        myCourtPushSwitch.on = realmUser.myCourtPushCheck
        distanceCourtPushSwitch.on = realmUser.distancePushCheck
        goodCourtPushSwitch.on = realmUser.starPushCheck
        
        self.view.addSubview(noticePushView)
        self.view.addSubview(myCourtPushView)
        self.view.addSubview(distanceCourtPushView)
        self.view.addSubview(goodCourtPushView)
        
        noticePushView.addSubview(noticePushLbl)
        myCourtPushView.addSubview(myCourtPushLbl)
        distanceCourtPushView.addSubview(distanceCourtPushLbl)
        goodCourtPushView.addSubview(goodCourtPushLbl)
        
        noticePushView.addSubview(noticePushSwitch)
        myCourtPushView.addSubview(myCourtPushSwitch)
        distanceCourtPushView.addSubview(distanceCourtPushSwitch)
        goodCourtPushView.addSubview(goodCourtPushSwitch)
        
        let timeLbl = UILabel(frame: CGRect(x: 20, y: 320, width: Util.screenSize.width-20, height: 40), text: "방해금지 시간대 설정", textAlignment: .Left, fontSize: 17)
        let startTime = UIDatePicker(frame: CGRect(x: 5, y: 370, width: Util.screenSize.width/2-15, height: 100))
        startTime.datePickerMode = .Time
        let timeAndLbl = UILabel(frame: CGRect(x: Util.screenSize.width/2-10, y: 370, width: 20, height: 100), text: "~", textAlignment: .Center, fontSize: 17)
        let endTime = UIDatePicker(frame: CGRect(x: Util.screenSize.width/2+15-5, y: 370, width: Util.screenSize.width/2-15, height: 100))
        endTime.datePickerMode = .Time
        
        startTime.date = realmUser.startPushTime
        endTime.date = realmUser.endPushTime
        
        self.view.addSubview(timeLbl)
        self.view.addSubview(startTime)
        self.view.addSubview(timeAndLbl)
        self.view.addSubview(endTime)
        
        
        func switchFn(){
            if noticePushSwitch.on == false && myCourtPushSwitch.on == false && distanceCourtPushSwitch.on == false && goodCourtPushSwitch.on == false{
                startTime.hidden = true
                endTime.hidden = true
                timeAndLbl.hidden = true
            }else{
                startTime.hidden = false
                endTime.hidden = false
                timeAndLbl.hidden = false
            }
        }
        switchFn()
        noticePushSwitch.addControlEvent(.TouchUpInside){
            switchFn()
        }
        myCourtPushSwitch.addControlEvent(.TouchUpInside){
            switchFn()
        }
        distanceCourtPushSwitch.addControlEvent(.TouchUpInside){
            switchFn()
        }
        goodCourtPushSwitch.addControlEvent(.TouchUpInside){
            switchFn()
        }
        
        CustomView.initLayout(self, title: "설정") { (_) in
            let user = Storage.copyUser()
            user.noticePushCheck = noticePushSwitch.on
            user.myCourtPushCheck = myCourtPushSwitch.on
            user.distancePushCheck = distanceCourtPushSwitch.on
            user.starPushCheck = goodCourtPushSwitch.on
            user.startPushTime = startTime.date
            user.endPushTime = endTime.date
            Storage.setRealmUser(user)
            //ajax통신 --- 알림, 시간대
        }
    }
}


