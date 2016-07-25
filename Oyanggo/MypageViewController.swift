//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire

class MypageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var nickLbl: UILabel!
    
    @IBOutlet var interestCourt: UIScrollView!
    @IBOutlet var myInsertCourt: UIScrollView!
    @IBOutlet var interestActivity: UIActivityIndicatorView!
    @IBOutlet var myInsertActivity: UIActivityIndicatorView!
    
    var user = Storage.getRealmUser()
    
    override func viewDidLoad() {
        print("MypageViewController viewDidLoad")
        dateInit()
        
        interestCourt.delegate = self
        myInsertCourt.delegate = self
        
        //슬라이드 효과
        interestCourt.pagingEnabled = true
        myInsertCourt.pagingEnabled = true
        interestCourt.showsVerticalScrollIndicator = false
        myInsertCourt.showsVerticalScrollIndicator = false
        interestCourt.showsHorizontalScrollIndicator = false
        myInsertCourt.showsHorizontalScrollIndicator = false
        
        
        let parameters : [String: AnyObject] = ["token": user.token, "userId": user.userId]
        Alamofire.request(.GET, URL.user_mypage, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data!
                let dic = Util.convertStringToDictionary(data)
                if let code = dic["code"] as? Int{
                    if code == 0{
                        if let interestList = dic["interestList"] as? [[String: AnyObject]]{
                            var interestCnt = interestList.count
                            if interestCnt == 0{
                                interestCnt = 1
                            }
                            //scrollView 총 넓이
                            self.interestCourt.contentSize = CGSizeMake(self.interestCourt.frame.size.width*CGFloat(interestCnt) ,self.interestCourt.frame.size.height)
                            self.interestData(interestList)
                        }
                        if let myCourtInsertList = dic["myCourtInsert"] as? [[String: AnyObject]]{
                            var myInsertCnt = myCourtInsertList.count
                            if myInsertCnt == 0{
                                myInsertCnt = 1
                            }
                            //scrollView 총 넓이
                            self.myInsertCourt.contentSize = CGSizeMake(self.myInsertCourt.frame.size.width*CGFloat(myInsertCnt) ,self.myInsertCourt.frame.size.height)
                            self.myInsertData(myCourtInsertList)
                        }
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
    
    
    
    
    
    //찜한 코트
    func setInterestImageLayout(tmpList : [[String: AnyObject]], courtInfo: UIScrollView){
        dispatch_async(dispatch_get_main_queue()) {
            var i : CGFloat = 0
            for obj in tmpList{
                if let imgUI = obj["image"] as? UIImage{
                    let imgBtn = UIButton(frame: CGRect(x: courtInfo.frame.width * i, y: 0, width: courtInfo.frame.width, height: courtInfo.frame.height-40), image: imgUI)
                    imgBtn.addControlEvent(.AllTouchEvents){
                        imgBtn.highlighted = false
                    }
                    imgBtn.addControlEvent(.TouchUpInside){
                        if let seq = obj["seq"] as? Int{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                            let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtVC")
                            (uvc as! CourtViewController).courtSeq = seq
                            uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                            self.presentViewController(uvc, animated: true, completion: nil)
                        }
                    }
                    courtInfo.addSubview(imgBtn)
                }
                
                var addr = ""
                if let addressText = obj["address"] as? String{
                    addr += addressText
                }
                let objLbl = UILabel(frame: CGRect(x: courtInfo.frame.width * i + 10, y: courtInfo.frame.height-40, width: courtInfo.frame.width-10, height: 40), text: "장소 : \(addr)")
                objLbl.font = UIFont(name: (objLbl.font?.fontName)!, size: 12)
                courtInfo.addSubview(objLbl)
                
                i += 1
            }
            self.interestActivity.stopAnimating()
            self.interestActivity.hidden = true
        }
    }
    
    //내가등록한 코트
    func setMyInsertImageLayout(tmpList : [[String: AnyObject]], courtInfo: UIScrollView){
        dispatch_async(dispatch_get_main_queue()) {
            var i : CGFloat = 0
            for obj in tmpList{
                
                if let imgUI = obj["image"] as? UIImage{
                    let imgBtn = UIButton(frame: CGRect(x: courtInfo.frame.width * i, y: 0, width: courtInfo.frame.width, height: courtInfo.frame.height-40), image: imgUI)
                    imgBtn.addControlEvent(.AllTouchEvents){
                        imgBtn.highlighted = false
                    }
                    imgBtn.addControlEvent(.TouchUpInside){
                        if let seq = obj["seq"] as? Int{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                            let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtVC")
                            (uvc as! CourtViewController).courtSeq = seq
                            uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                            self.presentViewController(uvc, animated: true, completion: nil)
                        }
                    }
                    courtInfo.addSubview(imgBtn)
                }
                
                var addr = ""
                if let addressText = obj["address"] as? String{
                    addr += addressText
                }
                let objLbl = UILabel(frame: CGRect(x: courtInfo.frame.width * i + 10, y: courtInfo.frame.height-40, width: courtInfo.frame.width-10, height: 40), text: "장소 : \(addr)")
                objLbl.font = UIFont(name: (objLbl.font?.fontName)!, size: 12)
                courtInfo.addSubview(objLbl)
                
                i += 1
            }
            self.myInsertActivity.stopAnimating()
            self.myInsertActivity.hidden = true
        }
    }
    
    
    
    
    
    
    
    
    //찜한 코트 리스트
    func interestData(list: [[String: AnyObject]]){
        if list.count == 0{
            let noneLbl = UILabel(frame: CGRect(x: 0, y: 0, width: interestCourt.frame.width, height: interestCourt.frame.height), text: "찜한 코트가 없습니다.")
            noneLbl.textAlignment = .Center
            noneLbl.font = UIFont(name: (noneLbl.font?.fontName)!, size: 20)
            dispatch_async(dispatch_get_main_queue()) {
                self.interestCourt.addSubview(noneLbl)
            }
        }else{
            var i : CGFloat = 0
            var tmpList = [[String: AnyObject]]()
            for obj in list{
                var tmpObj = [String: AnyObject]()
                if let img = obj["image"] as? String{
                    if let imgURL = NSURL(string: img){
                        if let imgData = NSData(contentsOfURL: imgURL){
                            if let imgUI = UIImage(data: imgData){
                                
                                tmpObj["image"] = imgUI
                                
                                if let addressText = obj["address"] as? String{
                                    tmpObj["address"] = addressText
                                }
                                if let addressText = obj["addressShort"] as? String{
                                    tmpObj["addressShort"] = addressText
                                }
                                if let seq = obj["seq"] as? Int{
                                    tmpObj["seq"] = seq
                                }
                                tmpList.append(tmpObj)
                                i += 1
                                if i == CGFloat(list.count){
                                    setInterestImageLayout(tmpList, courtInfo: self.interestCourt)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    //내가 등록한 코트 리스트
    func myInsertData(list: [[String: AnyObject]]){
        if list.count == 0{
            let noneLbl = UILabel(frame: CGRect(x: 0, y: 0, width: myInsertCourt.frame.width, height: myInsertCourt.frame.height), text: "내가 등록한 코트가 없습니다.")
            noneLbl.textAlignment = .Center
            noneLbl.font = UIFont(name: (noneLbl.font?.fontName)!, size: 20)
            dispatch_async(dispatch_get_main_queue()) {
                self.myInsertCourt.addSubview(noneLbl)
            }
        }else{
            var i : CGFloat = 0
            var tmpList = [[String: AnyObject]]()
            for obj in list{
                var tmpObj = [String: AnyObject]()
                if let img = obj["image"] as? String{
                    if let imgURL = NSURL(string: img){
                        if let imgData = NSData(contentsOfURL: imgURL){
                            if let imgUI = UIImage(data: imgData){
                                
                                tmpObj["image"] = imgUI
                                
                                if let addressText = obj["address"] as? String{
                                    tmpObj["address"] = addressText
                                }
                                if let addressText = obj["addressShort"] as? String{
                                    tmpObj["addressShort"] = addressText
                                }
                                if let seq = obj["seq"] as? Int{
                                    tmpObj["seq"] = seq
                                }
                                tmpList.append(tmpObj)
                                i += 1
                                if i == CGFloat(list.count){
                                    setMyInsertImageLayout(tmpList, courtInfo: self.myInsertCourt)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    //데이터 다시 수정
    func dateInit(){
        user = Storage.getRealmUser()
        nickLbl.text = user.nickName
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //개인정보 수정 클릭
    @IBAction func userConvertAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("userConvertVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        (uvc as! UserConvertViewController).mypageCtrl = self
        self.presentViewController(uvc, animated: true, completion: nil)
    }
}


