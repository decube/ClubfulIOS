//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var nickLbl: UILabel!
    
    @IBOutlet var interestCourt: UIScrollView!
    @IBOutlet var myInsertCourt: UIScrollView!
    @IBOutlet var interestActivity: UIActivityIndicatorView!
    @IBOutlet var myInsertActivity: UIActivityIndicatorView!
    
    
    let tmpList1 : [[String: AnyObject]] = [
        [
            "seq":1,
            "img":"http://mimgnews1.naver.net/image/117/2016/04/28/201604281925861126_1_99_20160428192603.jpg?type=w540",
            "address":"어디어디어디 홍대",
            "addressShort":"홍대"
        ]    ,[
            "seq":2,
            "img":"http://mimgnews1.naver.net/image/057/2016/02/03/280220808312_99_20160203180807.jpg?type=w540",
            "address":"어디어디어디 홍대2",
            "addressShort":"홍대2"
        ]

    ]
    
    let tmpList2 : [[String: AnyObject]] = [
        [
            "seq":1,
            "img":"https://usercontents-c.styleshare.kr/images/471840/640x-",
            "address":"어디어디어디 홍대",
            "addressShort":"홍대"
        ],
        [
            "seq":2,
            "img":"http://postfiles10.naver.net/20140106_41/rimnamjung_1388970514963FlByc_PNG/20140106095920.png?type=w2",
            "address":"어디어디어디 홍대2",
            "addressShort":"홍대2"
        ],[
            "seq":3,
            "img":"http://cdn.newsen.com/newsen/news_photo/2016/04/29/201604290207252810_2.jpg",
            "address":"어디어디어디 홍대3",
            "addressShort":"홍대3"
        ]
    ]
    
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
        
        var interestCnt = tmpList1.count
        var myInsertCnt = tmpList2.count
        if interestCnt == 0{
            interestCnt = 1
        }
        if myInsertCnt == 0{
            myInsertCnt = 1
        }
        //scrollView 총 넓이
        interestCourt.contentSize = CGSizeMake(interestCourt.frame.size.width*CGFloat(interestCnt) ,interestCourt.frame.size.height)
        myInsertCourt.contentSize = CGSizeMake(myInsertCourt.frame.size.width*CGFloat(myInsertCnt) ,myInsertCourt.frame.size.height)
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            self.interestData(self.tmpList1)
            self.myInsertData(self.tmpList2)
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
                
                if let addressText = obj["address"] as? String{
                    let objLbl = UILabel(frame: CGRect(x: courtInfo.frame.width * i + 10, y: courtInfo.frame.height-40, width: courtInfo.frame.width-10, height: 40), text: "장소 : \(addressText)")
                    objLbl.font = UIFont(name: (objLbl.font?.fontName)!, size: 12)
                    courtInfo.addSubview(objLbl)
                }
                
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
                
                if let addressText = obj["address"] as? String{
                    let objLbl = UILabel(frame: CGRect(x: courtInfo.frame.width * i + 10, y: courtInfo.frame.height-40, width: courtInfo.frame.width-10, height: 40), text: "장소 : \(addressText)")
                    objLbl.font = UIFont(name: (objLbl.font?.fontName)!, size: 12)
                    courtInfo.addSubview(objLbl)
                }
                
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
                if let img = obj["img"] as? String{
                    if let imgURL = NSURL(string: img){
                        if let imgData = NSData(contentsOfURL: imgURL){
                            if let imgUI = UIImage(data: imgData){
                                
                                tmpObj["image"] = imgUI
                                
                                if let addressText = obj["address"] as? String{
                                    tmpObj["address"] = addressText
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
                if let img = obj["img"] as? String{
                    if let imgURL = NSURL(string: img){
                        if let imgData = NSData(contentsOfURL: imgURL){
                            if let imgUI = UIImage(data: imgData){
                                
                                tmpObj["image"] = imgUI
                                
                                if let addressText = obj["address"] as? String{
                                    tmpObj["address"] = addressText
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
        let user = Storage.getRealmUser()
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


