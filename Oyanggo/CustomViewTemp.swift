////
////  CustomView.swift
////  Oyanggo
////
////  Created by guanho on 2016. 6. 17..
////  Copyright © 2016년 guanho. All rights reserved.
////
//
//import Foundation
//import UIKit
//import ActionKit
//
//class CustomViewTemp{
//    static func initLayout(ctrl : UIViewController, title: String, backVC : String = ""){
//        let statusBar = UIView().statusBar()
//        let (headerView, navBtn) = UIView().headerView(title, ctrl: ctrl, isStoryBoard: backVC)
//        let blackScreen = UIButton().blackScreen()
//        let navView = UIView().navView(ctrl)
//        CustomView.initAction(ctrl.view, statusBar: statusBar, headerView: headerView, navBtn: navBtn, blackScreen: blackScreen, navView: navView)
//    }
//    static func initAction(view : UIView, statusBar: UIView, headerView: UIView, navBtn : UIButton, blackScreen : UIButton, navView: UIView){
//        view.addSubview(statusBar)
//        view.addSubview(headerView)
//        view.addSubview(blackScreen)
//        view.addSubview(navView)
//        
//        //네비 클릭
//        navBtn.addControlEvent(.TouchUpInside){
//            blackScreen.hidden = false
//            let tmpRect = navView.frame
//            navView.frame = CGRect(x: Util.screenSize.width, y: 20, width: tmpRect.width, height: tmpRect.height)
//            navView.hidden = false
//            //애니메이션 적용
//            UIView.animateWithDuration(0.2, animations: {
//                navView.frame = CGRect(x: Util.screenSize.width-tmpRect.width, y: 20, width: tmpRect.width, height: tmpRect.height)
//                }, completion: nil)
//        }
//        blackScreen.addControlEvent(.TouchUpInside){
//            if navView.hidden == false{
//                let tmpRect = navView.frame
//                //애니메이션 적용
//                UIView.animateWithDuration(0.2, animations: {
//                    navView.frame = CGRect(x: Util.screenSize.width, y: 20, width: tmpRect.width, height: tmpRect.height)
//                    }, completion: {(_) in
//                        blackScreen.hidden = true
//                        navView.hidden = true
//                        navView.frame = CGRect(x: Util.screenSize.width, y: 0, width: tmpRect.width, height: tmpRect.height)
//                })
//            }
//        }
//    }
//}
//
//extension UIButton {
//    func blackScreen() -> UIButton{
//        self.frame = CGRect(x: 0, y: 0, width: Util.screenSize.width, height: Util.screenSize.height)
//        self.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
//        self.hidden = true
//        return self
//    }
//}
//
//extension UIView {
//    func statusBar() -> UIView{
//        self.frame = CGRect(x: 0, y: 0, width: Util.screenSize.width, height: 20)
//        self.backgroundColor = Util.statusColor
//        return self
//    }
//    func headerView(title : String, ctrl: UIViewController, isStoryBoard : String = "") -> (UIView, UIButton){
//        self.frame = CGRect(x: 0, y: 20, width: Util.screenSize.width, height: 60)
//        self.backgroundColor = Util.commonColor
//        let titleLbl = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height), text: title, color: UIColor.blackColor(), textAlignment: .Center, fontSize: 17)
//        let backBtn = UIButton(frame: CGRect(x: 10, y: 10, width: 40, height: 40), image: UIImage(named: "ic_back.png")!)
//        let navBtn = UIButton(frame: CGRect(x: self.frame.width-40, y: 15, width: 30, height: 30), image: UIImage(named: "ic_nav_icon.png")!)
//        
//        self.addSubview(titleLbl)
//        self.addSubview(backBtn)
//        self.addSubview(navBtn)
//        
//        backBtn.addControlEvent(.TouchUpInside){
//            if isStoryBoard == ""{
//                ctrl.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
//            }else{
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//                let uvc = storyBoard.instantiateViewControllerWithIdentifier(isStoryBoard)
//                uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
//                ctrl.presentViewController(uvc, animated: true, completion: nil)
//            }
//        }
//        return (self, navBtn)
//    }
//    func navView(ctrl : UIViewController) -> UIView{
//        self.frame = CGRect(x: Util.screenSize.width/2, y: 20, width: Util.screenSize.width/2, height: Util.screenSize.height-20)
//        self.backgroundColor = UIColor.whiteColor()
//        self.hidden = true
//        
//        let logView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 40))
//        let mainBtn = UIButton(frame: CGRect(x: 5, y: 2.5, width: 35, height: 35), image: UIImage(named: "ic_navi_main.png")!)
//        let logBtn = UIButton(frame: CGRect(x: 50, y: 0, width: logView.frame.width-110, height: logView.frame.height))
//        let settingBtn = UIButton(frame: CGRect(x: logView.frame.width-40, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_setting.png")!)
//        let mypageBtn = UIButton(frame: CGRect(x: 0, y: 41, width: self.frame.width, height: 40))
//        let friendBtn = UIButton(frame: CGRect(x: 0, y:90, width: self.frame.width, height: 40))
//        let messageBtn = UIButton(frame: CGRect(x: 0, y: 140, width: self.frame.width, height: 40))
//        let noticeBtn = UIButton(frame: CGRect(x: 0, y: 181, width: self.frame.width, height: 40))
//        let appInfoBtn = UIButton(frame: CGRect(x: 0, y: 230, width: self.frame.width, height: 40))
//        let guideBtn = UIButton(frame: CGRect(x: 0, y: 280, width: self.frame.width, height: 40))
//        let inquiryBtn = UIButton(frame: CGRect(x: 0, y: 330, width: self.frame.width, height: 40))
//        let courtInsertBtn = UIButton(frame: CGRect(x: 10, y: self.frame.height-50, width: self.frame.width-20, height: 40), text: "코트등록", color: UIColor.whiteColor(), fontSize: 17)
//        
//        let mypageImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_mypage.png")!)
//        let friendImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_friend.png")!)
//        let messageImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_message.png")!)
//        let noticeImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_notice.png")!)
//        let appInfoImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_appInfo.png")!)
//        let guideImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_guide.png")!)
//        let inquiryImg = UIImageView(frame: CGRect(x: 10, y: 7.5, width: 25, height: 25), image: UIImage(named: "ic_navi_inquiry.png")!)
//        
//        let logLbl = UILabel(frame: CGRect(x: 0, y: 0, width: logBtn.frame.width, height: logBtn.frame.height), text: "로그인", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
//        let mypageLbl = UILabel(frame: CGRect(x: 50, y: 0, width: mypageBtn.frame.width-50, height: mypageBtn.frame.height), text: "내정보", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
//        let friendLbl = UILabel(frame: CGRect(x: 50, y: 0, width: friendBtn.frame.width-50, height: friendBtn.frame.height), text: "친구초대", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
//        let messageLbl = UILabel(frame: CGRect(x: 50, y: 0, width: messageBtn.frame.width-50, height: messageBtn.frame.height), text: "쪽지함", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
//        let noticeLbl = UILabel(frame: CGRect(x: 50, y: 0, width: noticeBtn.frame.width-50, height: noticeBtn.frame.height), text: "공지사항", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
//        let appInfoLbl = UILabel(frame: CGRect(x: 50, y: 0, width: appInfoBtn.frame.width-50, height: appInfoBtn.frame.height), text: "앱정보", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
//        let guideLbl = UILabel(frame: CGRect(x: 50, y: 0, width: guideBtn.frame.width-50, height: guideBtn.frame.height), text: "가이드", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
//        let inquiryLbl = UILabel(frame: CGRect(x: 50, y: 0, width: inquiryBtn.frame.width-50, height: inquiryBtn.frame.height), text: "문의하기", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 17)
//        
//        logView.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
//        messageBtn.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
//        courtInsertBtn.boxLayout(radius: 6, backgroundColor: UIColor.blackColor())
//        
//        self.addSubview(logView)
//        self.addSubview(settingBtn)
//        self.addSubview(mypageBtn)
//        self.addSubview(friendBtn)
//        self.addSubview(messageBtn)
//        self.addSubview(noticeBtn)
//        self.addSubview(appInfoBtn)
//        self.addSubview(guideBtn)
//        self.addSubview(inquiryBtn)
//        self.addSubview(courtInsertBtn)
//        
//        logView.addSubview(mainBtn)
//        logView.addSubview(logBtn)
//        logView.addSubview(settingBtn)
//        
//        mypageBtn.addSubview(mypageImg)
//        friendBtn.addSubview(friendImg)
//        messageBtn.addSubview(messageImg)
//        noticeBtn.addSubview(noticeImg)
//        appInfoBtn.addSubview(appInfoImg)
//        guideBtn.addSubview(guideImg)
//        inquiryBtn.addSubview(inquiryImg)
//        
//        logBtn.addSubview(logLbl)
//        mypageBtn.addSubview(mypageLbl)
//        friendBtn.addSubview(friendLbl)
//        messageBtn.addSubview(messageLbl)
//        noticeBtn.addSubview(noticeLbl)
//        appInfoBtn.addSubview(appInfoLbl)
//        guideBtn.addSubview(guideLbl)
//        inquiryBtn.addSubview(inquiryLbl)
//        
//        func storyBoard(destination : String){
//            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//            let uvc = storyBoard.instantiateViewControllerWithIdentifier(destination)
//            if uvc.classForCoder != ctrl.classForCoder{
//                uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
//                ctrl.presentViewController(uvc, animated: true, completion: nil)
//            }
//        }
//        
//        mainBtn.addControlEvent(.TouchUpInside){
//            storyBoard("VC")
//        }
//        logBtn.addControlEvent(.TouchUpInside){
//            storyBoard("loginVC")
//        }
//        settingBtn.addControlEvent(.TouchUpInside){
//            storyBoard("settingVC")
//        }
//        mypageBtn.addControlEvent(.TouchUpInside){
//            storyBoard("mypageVC")
//        }
//        friendBtn.addControlEvent(.TouchUpInside){
//            
//        }
//        messageBtn.addControlEvent(.TouchUpInside){
//            storyBoard("memoVC")
//        }
//        noticeBtn.addControlEvent(.TouchUpInside){
//            storyBoard("noticeVC")
//        }
//        appInfoBtn.addControlEvent(.TouchUpInside){
//            storyBoard("appVersionVC")
//        }
//        guideBtn.addControlEvent(.TouchUpInside){
//            storyBoard("appGuideVC")
//        }
//        inquiryBtn.addControlEvent(.TouchUpInside){
//            storyBoard("inquiryVC")
//        }
//        courtInsertBtn.addControlEvent(.TouchUpInside){
//            storyBoard("courtCreateVC")
//        }
//        
//        return self
//    }
//}