//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire

class CourtViewController: UIViewController, UITextFieldDelegate, UIWebViewDelegate {
    var courtSeq : Int!
    @IBOutlet var gcmPushBtn: UIButton!
    @IBOutlet var courtMapBtn: UIButton!
    @IBOutlet var interestBtn: UIButton!
    @IBOutlet var interestLbl: UILabel!
    //이미지
    @IBOutlet var imageSlide: ImageSlideshow!
    //내용 뷰
    @IBOutlet var contentView: UIView!
    //내용 뷰 origin Y
    var contentViewY: CGFloat!
    //설명 textView
    @IBOutlet var descTextView: UITextView!
    //댓글 입력 필드
    @IBOutlet var replyInsertField: UITextField!
    //댓글 입력 버튼
    @IBOutlet var replyInsertBtn: UIButton!
    
    //웹뷰
    @IBOutlet var webView: UIWebView!
    //스핀
    @IBOutlet var activity: UIActivityIndicatorView!
    @IBOutlet var imageActivity: UIActivityIndicatorView!
    
    var court : [String: AnyObject]!
    let user = Storage.getRealmUser()
    //웹뷰 리플등록 액션
    var replyFn : String!
    
    override func viewDidLoad() {
        print("CourtViewController viewDidLoad")
        
        imageSlide.backgroundColor = UIColor.whiteColor()
        imageSlide.pageControlPosition = PageControlPosition.UnderScrollView
        imageSlide.pageControl.currentPageIndicatorTintColor = Util.commonColor
        imageSlide.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        imageSlide.zoomEnabled = true
        
        isCalling = true
        
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        
        let parameters : [String: AnyObject] = ["token": user.token, "seq": self.courtSeq]
        Alamofire.request(.GET, URL.court_detail, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data!
                let dic = Util.convertStringToDictionary(data)
                if let code = dic["code"] as? Int{
                    if code == 0{
                        if let courtTmp = dic["result"] as? [String: AnyObject]{
                            self.isCalling = false
                            self.court = courtTmp
                            self.interestLbl.text = "\(self.court["interest"]!)"
                            self.descTextView.text = "\(self.court["description"]!)"
                            self.replyFn = "\(self.court["replyFn"]!)"
                            //웹뷰 띄우기
                            self.webView.loadRequest(NSURLRequest(URL : NSURL(string: "\(self.court["replyUrl"]!)")!))
                            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                                if let imageList = self.court["imageList"] as? [[String: AnyObject]]{
                                    var imageSourceList = [ImageSource]()
                                    for image in imageList{
                                        let imgSource = ImageSource(image: UIImage(data: NSData(contentsOfURL: NSURL(string: image["image"] as! String)!)!)!)
                                        imageSourceList.append(imgSource)
                                    }
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.imageSlide.setImageInputs(imageSourceList)
                                        self.imageActivity.stopAnimating()
                                        self.imageActivity.hidden = true
                                    }
                                }
                            }
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
        
        
        
        
        
        gcmPushBtn.boxLayout(radius: 6)
        courtMapBtn.boxLayout(radius: 6)
        descTextView.boxLayout(borderWidth: 1, borderColor: UIColor.blackColor())
        descTextView.scrollToTop()
        replyInsertField.delegate = self
        replyInsertBtn.boxLayout(radius: 6, backgroundColor: Util.commonColor)
        contentViewY = contentView.frame.origin.y
        
        let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
        var starImage = "ic_star_select.png"
        if courtStar == nil{
            starImage = "ic_star_normal.png"
        }
        self.interestBtn.setImage(UIImage(named: starImage), forState: .Normal)
    }
    
    
    var isCalling = false
    //관심 클릭
    @IBAction func interestAction(sender: AnyObject) {
        if isCalling == false{
            isCalling = true
            let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
            var type = "good"
            if courtStar == nil{
                type = "goodCancel"
            }
            let parameters : [String: AnyObject] = ["token": user.token, "seq": self.courtSeq, "type": type]
            Alamofire.request(.GET, URL.court_interest, parameters: parameters)
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    self.isCalling = false
                    let data : NSData = response.data!
                    let dic = Util.convertStringToDictionary(data)
                    if let code = dic["code"] as? Int{
                        if code == 0{
                            var starImage = "ic_star_normal.png"
                            if courtStar == nil{
                                starImage = "ic_star_select.png"
                                Storage.setStorage("courtStar_\(self.courtSeq)", value: true)
                            }else{
                                Storage.removeStorage("courtStar_\(self.courtSeq)")
                            }
                            //애니메이션 적용
                            self.interestBtn.alpha = 0
                            self.interestBtn.setImage(UIImage(named: starImage), forState: .Normal)
                            UIView.animateWithDuration(0.4, animations: {
                                self.interestBtn.alpha = 1
                                self.interestLbl.text = "\(dic["cnt"]!)"
                                }, completion: nil)
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
    }
    
    
    
    //gcm 클릭
    @IBAction func gcmPushAction(sender: AnyObject) {
        print("gcm")
    }
    
    //약도보기 클릭
    @IBAction func courtMapAction(sender: AnyObject) {
        if let latitude = court["latitude"] as? Double{
            if let longitude = court["longitude"] as? Double{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
                let uvc = storyBoard.instantiateViewControllerWithIdentifier("courtMapVC")
                (uvc as! CourtMapViewController).courtLatitude = latitude
                (uvc as! CourtMapViewController).courtLongitude = longitude
                uvc.modalTransitionStyle = UIModalTransitionStyle.CoverVertical
                self.presentViewController(uvc, animated: true, completion: nil)
            }
        }
    }
    
    //리플 등록 클릭
    @IBAction func replyInsertAction(sender: AnyObject) {
        if isCalling == false{
            isCalling = true
            if user.isLogin == -1{
                self.webView.stringByEvaluatingJavaScriptFromString("\(self.replyFn)")
                isCalling = false
                Util.alert(message: "리플등록은 로그인을 하셔야 가능합니다.", ctrl: self)
            }else{
                if replyInsertField.text?.characters.count < 1{
                    self.webView.stringByEvaluatingJavaScriptFromString("\(self.replyFn)")
                    isCalling = false
                }else{
                    let parameters : [String: AnyObject] = ["token": user.token, "seq": courtSeq, "context": replyInsertField.text!, "id": user.userId]
                    self.replyInsertField.text = ""
                    Alamofire.request(.GET, URL.court_replyInsert, parameters: parameters)
                        .validate(statusCode: 200..<300)
                        .validate(contentType: ["application/json"])
                        .responseData { response in
                            let data : NSData = response.data!
                            let dic = Util.convertStringToDictionary(data)
                            if let code = dic["code"] as? Int{
                                if code == 0{
                                    self.webView.stringByEvaluatingJavaScriptFromString("\(self.replyFn)")
                                    self.isCalling = false
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
            }
        }
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //웹뷰 가져옴
    func webViewDidFinishLoad(webView: UIWebView) {
        activity.stopAnimating()
        activity.hidden = true
    }
    
    //키보드 생김/사라짐 셀렉터
    override func viewWillAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    //view 사라지기 전 작동
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    //키보드생길때
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            contentView.frame.origin.y = contentViewY - keyboardSize.height
        }
    }
    //키보드없어질때
    func keyboardWillHide(notification: NSNotification) {
        contentView.frame.origin.y = contentViewY
    }
    
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
}


