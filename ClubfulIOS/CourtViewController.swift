//
//  CourtViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import ImageSlideshow

class CourtViewController : UIViewController, UITextFieldDelegate, UIWebViewDelegate{
    var courtSeq : Int!
    
    //스핀
    @IBOutlet var imageSpin: UIActivityIndicatorView!
    @IBOutlet var replySpin: UIActivityIndicatorView!
    @IBOutlet var spin: UIActivityIndicatorView!
    
    
    @IBOutlet var interestBtn: UIButton!
    @IBOutlet var interestLbl: UILabel!
    //헤더라벨
    @IBOutlet var headerLbl: UILabel!
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
    
    
    var court : [String: AnyObject]!
    let user = Storage.getRealmUser()
    //웹뷰 리플등록 액션
    var replyFn : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CourtViewController viewDidLoad")
        
        
        spin.hidden = true
        
        imageSlide.backgroundColor = UIColor.whiteColor()
        imageSlide.pageControlPosition = PageControlPosition.UnderScrollView
        imageSlide.pageControl.currentPageIndicatorTintColor = Util.commonColor
        imageSlide.pageControl.pageIndicatorTintColor = UIColor.blackColor()
        imageSlide.zoomEnabled = true
        
        
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        
        let parameters : [String: AnyObject] = ["token": user.token, "seq": self.courtSeq]
        URL.request(self, url: URL.apiServer+URL.api_court_detail, param: parameters, callback: { (dic) in
            if let courtTmp = dic["result"] as? [String: AnyObject]{
                self.court = courtTmp
                self.interestLbl.text = "\(self.court["interest"]!)"
                self.descTextView.text = "\(self.court["description"]!)"
                self.replyFn = "\(self.court["replyFn_ios"]!)"
                self.headerLbl.text = "\(self.court["cname"]!) (\(self.court["categoryName"]!))"
                //웹뷰 띄우기
                self.webView.loadRequest(NSURLRequest(URL : NSURL(string: "\(self.court["replyUrl"]!)")!))
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                    if let imageList = self.court["imageList"] as? [[String: AnyObject]]{
                        var imageSourceList = [ImageSource]()
                        for image in imageList{
                            if let imageUrl = NSURL(string: image["image"] as! String){
                                if let imageData = NSData(contentsOfURL: imageUrl){
                                    if let imageUI = UIImage(data: imageData){
                                        let imgSource = ImageSource(image: imageUI)
                                        imageSourceList.append(imgSource)
                                    }
                                }
                            }
                        }
                        dispatch_async(dispatch_get_main_queue()) {
                            self.imageSlide.setImageInputs(imageSourceList)
                            self.imageSpin.stopAnimating()
                            self.imageSpin.hidden = true
                        }
                    }
                }
            }
        })
        
        descTextView.scrollToTop()
        replyInsertField.delegate = self
        contentViewY = contentView.frame.origin.y
        
        let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
        var starImage = "ic_star_s.png"
        if courtStar == nil{
            starImage = "ic_star_n.png"
        }
        self.interestBtn.setImage(UIImage(named: starImage), forState: .Normal)
    }
    
    
    //관심 클릭
    @IBAction func interestAction(sender: AnyObject) {
        if spin.hidden == false{
            return
        }
        spin.hidden = false
        spin.startAnimating()
        
        let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
        var type = "good"
        if courtStar == nil{
            type = "goodCancel"
        }
        let parameters : [String: AnyObject] = ["token": user.token, "seq": self.courtSeq, "type": type]
        URL.request(self, url: URL.apiServer+URL.api_court_interest, param: parameters, callback: { (dic) in
            self.spin.hidden = true
            self.spin.stopAnimating()
            var starImage = "ic_star_n.png"
            if courtStar == nil{
                starImage = "ic_star_s.png"
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
        })
    }
    
    
    
    //gcm 클릭
    @IBAction func gcmPushAction(sender: AnyObject) {
        print("gcm")
    }
    
    //약도보기 클릭
    @IBAction func courtMapAction(sender: AnyObject) {
        if let latitude = court["latitude"] as? Double{
            if let longitude = court["longitude"] as? Double{
                let sname : String = "내위치".queryValue()
                let sx : Double = Storage.latitude
                let sy : Double = Storage.longitude
                let ename : String = "\(court["address"]!)".queryValue()
                let ex : Double = latitude
                let ey : Double = longitude
                let simplemapUrl = "https://m.map.naver.com/route.nhn?menu=route&sname=\(sname)&sx=\(sx)&sy=\(sy)&ename=\(ename)&ex=\(ex)&ey=\(ey)&pathType=1&showMap=true"
                if let url = NSURL(string: simplemapUrl){
                    if UIApplication.sharedApplication().canOpenURL(url) {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
            }
        }
    }
    
    //리플 등록 클릭
    @IBAction func replyInsertAction(sender: AnyObject) {
        if spin.hidden == false{
            return
        }
        spin.hidden = false
        spin.startAnimating()
        
        if user.isLogin == -1{
            self.webView.stringByEvaluatingJavaScriptFromString("\(self.replyFn)")
            self.spin.hidden = true
            self.spin.stopAnimating()
            Util.alert(self, message: "리플등록은 로그인을 하셔야 가능합니다.")
        }else{
            if replyInsertField.text?.characters.count < 1{
                self.webView.stringByEvaluatingJavaScriptFromString("\(self.replyFn)")
                self.spin.hidden = true
                self.spin.stopAnimating()
            }else{
                let parameters : [String: AnyObject] = ["token": user.token, "seq": courtSeq, "context": replyInsertField.text!, "id": user.userId]
                self.replyInsertField.text = ""
                URL.request(self, url: URL.apiServer+URL.api_court_replyInsert, param: parameters, callback: { (dic) in
                    self.webView.stringByEvaluatingJavaScriptFromString("\(self.replyFn)")
                    self.spin.hidden = true
                    self.spin.stopAnimating()
                })
            }
        }
    }
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    //웹뷰 가져옴
    func webViewDidFinishLoad(webView: UIWebView) {
        replySpin.stopAnimating()
        replySpin.hidden = true
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
