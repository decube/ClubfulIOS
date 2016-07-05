//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import ImageSlideshow

class CourtViewController: UIViewController, UITextFieldDelegate {
    var courtSeq = -1
    
    var courtReplyInsertView : UIView!
    
    override func viewDidLoad() {
        print("CourtViewController viewDidLoad")
        
        let slideshow = ImageSlideshow(frame: CGRect(x: 0, y: 85, width: Util.screenSize.width, height: 200))
        
        slideshow.backgroundColor = UIColor.whiteColor()
        slideshow.pageControlPosition = PageControlPosition.UnderScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = Util.commonColor
        slideshow.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        slideshow.zoomEnabled = true
        
        self.view.addSubview(slideshow)
        
        var imageList = [ImageSource]()
        for j in 0...6{
            imageList.append(ImageSource(image: UIImage(named: "courtTemp.png")!))
        }
        slideshow.setImageInputs(imageList)
        
        let gcmBtn = UIButton(frame: CGRect(x: 10, y: 290, width: 100, height: 30), text: "관심&주변 호출", color: UIColor.whiteColor(), fontSize: 14)
        let mapBtn = UIButton(frame: CGRect(x: 120, y: 290, width: 100, height: 30), text: "약도보기", fontSize: 14)
        let starBtn = UIButton(frame: CGRect(x: Util.screenSize.width-55, y: 270, width: 30, height: 30), image: UIImage(named: "ic_star_normal.png")!)
        let starLbl = UILabel(frame: CGRect(x: Util.screenSize.width-55, y: 300, width: 30, height: 20), text: "10", textAlignment: .Center, fontSize: 15)
        gcmBtn.boxLayout(radius: 6, backgroundColor: UIColor.blackColor())
        mapBtn.boxLayout(radius: 6, backgroundColor: Util.commonColor)
        
        self.view.addSubview(gcmBtn)
        self.view.addSubview(mapBtn)
        self.view.addSubview(starBtn)
        self.view.addSubview(starLbl)
        
        gcmBtn.addControlEvent(.TouchUpInside){
            print("gcm")
        }
        mapBtn.addControlEvent(.TouchUpInside){
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtMapVC")
            (uvc as! CourtMapViewController).courtLatitude = 37.303030
            (uvc as! CourtMapViewController).courtLongitude = 126.6239304
            uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
            self.presentViewController(uvc, animated: true, completion: nil)
        }
        var isStar = false
        starBtn.addControlEvent(.TouchUpInside){
            var starImage = "ic_star_normal.png"
            isStar = !isStar
            if isStar{
                starImage = "ic_star_select.png"
            }
            //애니메이션 적용
            starBtn.alpha = 0
            starBtn.setImage(UIImage(named: starImage), forState: .Normal)
            UIView.animateWithDuration(0.4, animations: {
                starBtn.alpha = 1
            }, completion: nil)
        }
        
        
        let etcInfoScrollView = UIScrollView(frame: CGRect(x: 0, y: 325, width: Util.screenSize.width, height: Util.screenSize.height-335))
        let courtDesc = UITextView(frame: CGRect(x: 5, y: 0, width: etcInfoScrollView.frame.width-10, height: 60))
        
        courtDesc.boxLayout(borderWidth: 1, borderColor: UIColor.blackColor())
        courtDesc.editable = false
        courtDesc.text = "가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가가"
        
        self.view.addSubview(etcInfoScrollView)
        etcInfoScrollView.addSubview(courtDesc)
        
        
        var replyI : CGFloat = 0
        let replyObjHeight : CGFloat = 40
        for j in 0 ... 20{
            let replyView = UIView(frame: CGRect(x: 0, y: 65+replyObjHeight*replyI, width: etcInfoScrollView.frame.width, height: replyObjHeight-1))
            let replyLbl = UILabel(frame: CGRect(x: 5, y: 0, width: replyView.frame.width-5, height: replyView.frame.height), text: "리플리플가나다", color: UIColor.blackColor(), textAlignment: .Left, fontSize: 14)
            
            replyLbl.numberOfLines = 2
            replyView.boxBorder(.Bottom, borderWidth: 1, color: UIColor.blackColor())
            
            etcInfoScrollView.addSubview(replyView)
            replyView.addSubview(replyLbl)
            replyI += 1
        }
        etcInfoScrollView.contentSize = CGSize(width: etcInfoScrollView.frame.width, height: replyObjHeight*replyI+110)
        
        
        courtReplyInsertView = UIView(frame: CGRect(x: 0, y: Util.screenSize.height-50, width: Util.screenSize.width, height: 50))
        let courtReplyField = UITextField(frame: CGRect(x: 10, y: 10, width: courtReplyInsertView.frame.width-110, height: courtReplyInsertView.frame.height-20), placeholder: "리플 입력", textAlignment: .Left, delegate: self, fontSize: 15)
        courtReplyInsertView.backgroundColor = UIColor.whiteColor()
        let courtReplyBtn = UIButton(frame: CGRect(x: courtReplyInsertView.frame.width-90, y: 5, width: 80, height: 40), text: "리플 입력", fontSize: 15)
        
        courtReplyBtn.boxLayout(radius: 6, backgroundColor: Util.commonColor)
        
        self.view.addSubview(courtReplyInsertView)
        courtReplyInsertView.addSubview(courtReplyField)
        courtReplyInsertView.addSubview(courtReplyBtn)
        
        
        CustomView.initLayout(self, title: "코트정보 보기")
    }
    
    
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CourtViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            courtReplyInsertView.frame = CGRect(x: 0, y: Util.screenSize.height-40-keyboardSize.height, width: Util.screenSize.width, height: 40)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        courtReplyInsertView.frame = CGRect(x: 0, y: Util.screenSize.height-50, width: Util.screenSize.width, height: 50)
    }
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}


