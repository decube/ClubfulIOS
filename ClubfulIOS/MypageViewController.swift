//
//  MypageViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var interestCourt: UIScrollView!
    @IBOutlet var createCourt: UIScrollView!
    @IBOutlet var interestSpin: UIActivityIndicatorView!
    @IBOutlet var createSpin: UIActivityIndicatorView!
    
    var user = Storage.getRealmUser()
    
    var nonUserView : NonUserView!
    override func viewWillAppear(animated: Bool) {
        print("MypageViewController viewWillAppear")
        if nonUserView == nil{
            if let customView = NSBundle.mainBundle().loadNibNamed("NonUserView", owner: self, options: nil).first as? NonUserView {
                customView.frame = self.view.frame
                nonUserView = customView
                layout()
            }
        }else{
            layout()
        }
    }

    
    override func viewDidLoad() {
        print("MypageViewController viewDidLoad")
        
        interestCourt.delegate = self
        createCourt.delegate = self
        
        //슬라이드 효과
        interestCourt.pagingEnabled = true
        createCourt.pagingEnabled = true
        interestCourt.showsVerticalScrollIndicator = false
        createCourt.showsVerticalScrollIndicator = false
        interestCourt.showsHorizontalScrollIndicator = false
        createCourt.showsHorizontalScrollIndicator = false
    }
    
    
    func layout(){
        if user.isLogin != -1{
            self.interestCourt.subviews.forEach({$0.removeFromSuperview()})
            self.createCourt.subviews.forEach({$0.removeFromSuperview()})
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
            let parameters : [String: AnyObject] = ["token": user.token, "userId": user.userId]
            URL.request(self, url: URL.apiServer+URL.api_user_mypage, param: parameters, callback: { (dic) in
                if let interestList = dic["interestList"] as? [[String: AnyObject]]{
                    var interestCnt = interestList.count
                    if interestCnt == 0{
                        interestCnt = 1
                    }
                    //scrollView 총 넓이
                    self.interestCourt.contentSize = CGSizeMake(self.interestCourt.frame.size.width*CGFloat(interestCnt) ,self.interestCourt.frame.size.height)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        self.interestData(interestList)
                    })
                }
                if let myCourtInsertList = dic["myCourtInsert"] as? [[String: AnyObject]]{
                    var myInsertCnt = myCourtInsertList.count
                    if myInsertCnt == 0{
                        myInsertCnt = 1
                    }
                    //scrollView 총 넓이
                    self.createCourt.contentSize = CGSizeMake(self.createCourt.frame.size.width*CGFloat(myInsertCnt) ,self.createCourt.frame.size.height)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                        self.myInsertData(myCourtInsertList)
                    })
                }
            })
        }else{
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
            self.view.addSubview(nonUserView)
        }
    }
    
    //사이즈 비율 계산
    func calLayoutRate(fullSize fullSize: CGSize, imageSize: CGSize) -> CGRect{
        var widthValue = fullSize.width
        var heightValue = fullSize.height
        let imageWidth = imageSize.width
        let imageHeight = imageSize.height
        
        let rateWidth = imageWidth/widthValue
        let rateHeight = imageHeight/heightValue
        
        if rateWidth > rateHeight{
            heightValue = widthValue * imageHeight / imageWidth
        }else{
            widthValue = heightValue * imageWidth / imageHeight
        }
        return CGRect(x: (fullSize.width-widthValue)/2, y: (fullSize.height-heightValue)/2, width: widthValue, height: heightValue)
    }
    
    //찜한 코트
    func setInterestImageLayout(tmpList : [[String: AnyObject]], courtInfo: UIScrollView){
        dispatch_async(dispatch_get_main_queue()) {
            var i : CGFloat = 0
            for obj in tmpList{
                if let imgUI = obj["image"] as? UIImage{
                    let imgBtn = UIButton(frame: CGRect(x: courtInfo.frame.width * i, y: 0, width: courtInfo.frame.width, height: courtInfo.frame.height-40))
                    imgBtn.addAction(.AllTouchEvents){
                        imgBtn.highlighted = false
                    }
                    imgBtn.addAction(.TouchUpInside){
                        if let seq = obj["seq"] as? Int{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                            let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtVC")
                            (uvc as! CourtViewController).courtSeq = seq
                            uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                            self.presentViewController(uvc, animated: true, completion: nil)
                        }
                    }
                    courtInfo.addSubview(imgBtn)
                    
                    let imgView = UIImageView(frame: self.calLayoutRate(fullSize: imgBtn.frame.size, imageSize: imgUI.size))
                    imgView.image = imgUI
                    imgBtn.addSubview(imgView)
                }
                
                let infoStr = "\(obj["cname"]!) (\(obj["categoryName"]!) / \(obj["address"]!))"
                let objLbl = UILabel(frame: CGRect(x: courtInfo.frame.width * i + 10, y: courtInfo.frame.height-40, width: courtInfo.frame.width-10, height: 40))
                objLbl.text = "\(infoStr)"
                objLbl.font = UIFont(name: (objLbl.font?.fontName)!, size: 12)
                courtInfo.addSubview(objLbl)
                
                i += 1
            }
            self.interestSpin.stopAnimating()
            self.interestSpin.hidden = true
        }
    }
    
    //내가등록한 코트
    func setMyInsertImageLayout(tmpList : [[String: AnyObject]], courtInfo: UIScrollView){
        dispatch_async(dispatch_get_main_queue()) {
            var i : CGFloat = 0
            for obj in tmpList{
                
                if let imgUI = obj["image"] as? UIImage{
                    let imgBtn = UIButton(frame: CGRect(x: courtInfo.frame.width * i, y: 0, width: courtInfo.frame.width, height: courtInfo.frame.height-40))
                    imgBtn.addAction(.AllTouchEvents){
                        imgBtn.highlighted = false
                    }
                    imgBtn.addAction(.TouchUpInside){
                        if let seq = obj["seq"] as? Int{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                            let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtVC")
                            (uvc as! CourtViewController).courtSeq = seq
                            uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                            self.presentViewController(uvc, animated: true, completion: nil)
                        }
                    }
                    courtInfo.addSubview(imgBtn)
                    
                    let imgView = UIImageView(frame: self.calLayoutRate(fullSize: imgBtn.frame.size, imageSize: imgUI.size))
                    imgView.image = imgUI
                    imgBtn.addSubview(imgView)
                }
                
                let infoStr = "\(obj["cname"]!) (\(obj["categoryName"]!) / \(obj["address"]!))"
                let objLbl = UILabel(frame: CGRect(x: courtInfo.frame.width * i + 10, y: courtInfo.frame.height-40, width: courtInfo.frame.width-10, height: 40))
                objLbl.text = "\(infoStr)"
                objLbl.font = UIFont(name: (objLbl.font?.fontName)!, size: 12)
                courtInfo.addSubview(objLbl)
                
                i += 1
            }
            self.createSpin.stopAnimating()
            self.createSpin.hidden = true
        }
    }
    
    
    
    
    
    
    
    
    //찜한 코트 리스트
    func interestData(list: [[String: AnyObject]]){
        if list.count == 0{
            let noneLbl = UILabel(frame: CGRect(x: 0, y: 0, width: interestCourt.frame.width, height: interestCourt.frame.height))
            noneLbl.text = "찜한 코트가 없습니다."
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
                                if let categoryName = obj["categoryName"] as? String{
                                    tmpObj["categoryName"] = categoryName
                                }
                                if let cname = obj["cname"] as? String{
                                    tmpObj["cname"] = cname
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
            let noneLbl = UILabel(frame: CGRect(x: 0, y: 0, width: createCourt.frame.width, height: createCourt.frame.height))
            noneLbl.text = "찜한 코트가 없습니다."
            noneLbl.textAlignment = .Center
            noneLbl.font = UIFont(name: (noneLbl.font?.fontName)!, size: 20)
            dispatch_async(dispatch_get_main_queue()) {
                self.createCourt.addSubview(noneLbl)
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
                                if let categoryName = obj["categoryName"] as? String{
                                    tmpObj["categoryName"] = categoryName
                                }
                                if let cname = obj["cname"] as? String{
                                    tmpObj["cname"] = cname
                                }
                                if let seq = obj["seq"] as? Int{
                                    tmpObj["seq"] = seq
                                }
                                tmpList.append(tmpObj)
                                i += 1
                                if i == CGFloat(list.count){
                                    setMyInsertImageLayout(tmpList, courtInfo: self.createCourt)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    //개인정보 수정 클릭
    @IBAction func userConvertAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("userConvertVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
    
    //쪽지함 클릭
    @IBAction func messageAction(sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let uvc = storyBoard.instantiateViewControllerWithIdentifier("messageVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
        self.presentViewController(uvc, animated: true, completion: nil)
    }
}