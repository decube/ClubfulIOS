//
//  CourtViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtViewController : UIViewController, UITextFieldDelegate, UIWebViewDelegate, UIScrollViewDelegate{
    var courtSeq : Int!
    
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat = 0
    //스핀
    @IBOutlet var imageSpin: UIActivityIndicatorView!
    @IBOutlet var replySpin: UIActivityIndicatorView!
    @IBOutlet var spin: UIActivityIndicatorView!
    
    
    @IBOutlet var interestBtn: UIButton!
    @IBOutlet var interestLbl: UILabel!
    //헤더라벨
    @IBOutlet var headerLbl: UILabel!
    //이미지 부모 뷰
    @IBOutlet var imageView: UIView!
    //이미지
    @IBOutlet var imageSlide: UIScrollView!
    //설명 textView
    @IBOutlet var descTextView: UITextView!
    //댓글 입력 필드
    @IBOutlet var replyInsertField: UITextField!
    
    //웹뷰
    @IBOutlet var webView: UIWebView!
    
    
    
    //이미지 URL 저장
    var imageURLList = [String]()
    //이미지 리스트 저장
    var imageViewList = [UIImageView]()
    //이미지 하단 네비 저장
    var imageBottomIndex : [UIView] = []
    
    
    var court : [String: AnyObject]!
    
    //웹뷰 리플등록 액션
    var replyFn : String!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.1)
            DispatchQueue.main.async {
                self.scrollViewHeight = self.scrollView.contentSize.height
            }
        }
        
        
        spin.isHidden = true
        imageSlide.delegate = self
        //슬라이드 효과
        imageSlide.isPagingEnabled = true
        imageSlide.showsVerticalScrollIndicator = false
        imageSlide.showsHorizontalScrollIndicator = false
        
        //웹뷰 딜리게이트 추가
        self.webView.delegate = self
        let parameters : [String: AnyObject] = ["seq": self.courtSeq as AnyObject]
        URLReq.request(self, url: URLReq.apiServer+URLReq.api_court_detail, param: parameters, callback: { (dic) in
            if let courtTmp = dic["result"] as? [String: AnyObject]{
                self.court = courtTmp
                self.interestLbl.text = "\(self.court["interest"]!)"
                self.descTextView.text = "\(self.court["description"]!)"
                self.replyFn = "\(self.court["replyFn_ios"]!)"
                self.headerLbl.text = "\(self.court["cname"]!) (\(self.court["categoryName"]!))"
                //웹뷰 띄우기
                self.webView.loadRequest(URLRequest(url : Foundation.URL(string: "\(self.court["replyUrl"]!)")!))
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInitiated).async {
                    if let imageListValue = self.court["imageList"] as? [[String: AnyObject]]{
                        for image in imageListValue{
                            let imageURL = image["image"] as! String
                            if let imageUrl = Foundation.URL(string: imageURL){
                                if let imageData = try? Data(contentsOf: imageUrl){
                                    if let imageUI = UIImage(data: imageData){
                                        let imgView = UIImageView(image: imageUI)
                                        self.imageURLList.append(imageURL)
                                        self.imageViewList.append(imgView)
                                    }
                                }
                            }
                        }
                        for _ in 0 ..< Int(self.imageViewList.count){
                            let ovalView = UIView()
                            self.imageBottomIndex.append(ovalView)
                        }
                        
                        self.setImages()
                    }
                }
            }
        })
        
        descTextView.scrollToTop()
        replyInsertField.delegate = self
        
        let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
        var starImage = "ic_star_s.png"
        if courtStar == nil{
            starImage = "ic_star_n.png"
        }
        self.interestBtn.setImage(UIImage(named: starImage), for: UIControlState())
    }
    
    
    func setImages(){
        DispatchQueue.main.async {
            self.imageSlide.subviews.forEach({$0.removeFromSuperview()})
            self.imageView.subviews.forEach({ (v) in
                if String(describing: v.classForCoder) == "UIView"{
                    v.removeFromSuperview()
                }
            })
            
            var idx : CGFloat = 0
            for imageSource in self.imageViewList{
                var frame = self.calLayoutRate(fullSize: self.imageSlide.frame.size, imageSize: imageSource.image!.size)
                frame.origin.x = frame.origin.x+(self.imageSlide.frame.width*idx)
                imageSource.frame = frame
                
                self.imageSlide.addSubview(imageSource)
                idx += 1
            }
            
            
            
            //더블클릭
            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.interestAction(_:)))
            doubleTap.numberOfTapsRequired = 2
            self.imageSlide.addGestureRecognizer(doubleTap)
            //길게클릭
            self.imageSlide.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:))))
            
            
            self.imageSlide.isUserInteractionEnabled = true
            self.imageSlide.contentSize.width = self.imageSlide.frame.width*idx
            self.imageSlide.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            
            
            //이미지 하단 네비
            let ovalSize: CGFloat = 10
            let ovalMargin: CGFloat = 10
            let firstX = (self.imageView.frame.width - idx*(ovalSize+ovalMargin))/2
            var i = 0
            for ovalView in self.imageBottomIndex{
                ovalView.frame = CGRect(x: firstX+(ovalMargin)/2+(ovalSize+ovalMargin) * CGFloat(i), y: self.imageView.frame.height-ovalSize, width: ovalSize, height: ovalSize)
                ovalView.layer.cornerRadius = ovalSize/2
                if i == 0{
                    ovalView.backgroundColor = Util.commonColor
                }else{
                    ovalView.backgroundColor = UIColor.black
                }
                self.imageView.addSubview(ovalView)
                i += 1
            }
            
            self.imageSpin.stopAnimating()
            self.imageSpin.isHidden = true
        }
    }
    
    
    
    //길게 클릭
    func longPressed(_ sender: UILongPressGestureRecognizer){
        if sender.state == .ended {
            //Do Whatever You want on End of Gesture
        }else if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            Util.imageSaveHandler(self, imageUrl: "\(self.imageURLList[self.idx])", image: self.imageViewList[self.idx].image!)
        }
    }
    
    
    
    
    
    
    
    var idx = 0
    //스크롤뷰 슬라이더 딜리게이트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = Double(scrollView.bounds.size.width)
        let offset = Double(scrollView.contentOffset.x)
        let idx = Int(offset/width)
        if self.idx != idx{
            self.idx = idx
            self.imageBottomIndex.forEach({ (__) in
                __.backgroundColor = UIColor.black
            })
            self.imageBottomIndex[idx].backgroundColor = Util.commonColor
        }
    }
    
    
    
    
    
    
    //사이즈 비율 계산
    func calLayoutRate(fullSize: CGSize, imageSize: CGSize) -> CGRect{
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
    
    
    
    
    
    
    
    //관심 클릭
    @IBAction func interestAction(_ sender: AnyObject) {
        if spin.isHidden == false{
            return
        }
        spin.isHidden = false
        spin.startAnimating()
        
        let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
        var type = "good"
        if courtStar == nil{
            type = "goodCancel"
        }
        let parameters : [String: AnyObject] = ["seq": self.courtSeq as AnyObject, "type": type as AnyObject]
        URLReq.request(self, url: URLReq.apiServer+URLReq.api_court_interest, param: parameters, callback: { (dic) in
            self.spin.isHidden = true
            self.spin.stopAnimating()
            var starImage = "ic_star_n.png"
            if courtStar == nil{
                starImage = "ic_star_s.png"
                Storage.setStorage("courtStar_\(self.courtSeq)", value: true as AnyObject)
            }else{
                Storage.removeStorage("courtStar_\(self.courtSeq)")
            }
            //애니메이션 적용
            self.interestBtn.alpha = 0
            self.interestBtn.setImage(UIImage(named: starImage), for: UIControlState())
            UIView.animate(withDuration: 0.4, animations: {
                self.interestBtn.alpha = 1
                self.interestLbl.text = "\(dic["cnt"]!)"
            }, completion: nil)
        })
    }
    
    
    
    
    
    
    //gcm 클릭
    @IBAction func gcmPushAction(_ sender: AnyObject) {
        print("gcm")
    }
    
    
    
    
    
    //약도보기 클릭
    @IBAction func courtMapAction(_ sender: AnyObject) {
        if let latitude = court["latitude"] as? Double{
            if let longitude = court["longitude"] as? Double{
                let sname : String = "내위치".queryValue()
                let sx : Double = Storage.latitude
                let sy : Double = Storage.longitude
                let ename : String = "\(court["address"]!)".queryValue()
                let ex : Double = latitude
                let ey : Double = longitude
                let simplemapUrl = "https://m.map.naver.com/route.nhn?menu=route&sname=\(sname)&sx=\(sx)&sy=\(sy)&ename=\(ename)&ex=\(ex)&ey=\(ey)&pathType=1&showMap=true"
                if let url = Foundation.URL(string: simplemapUrl){
                    if UIApplication.shared.canOpenURL(url) {
                        if #available(iOS 10.0, *) {
                            UIApplication.shared.open(url, options: [:])
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                }
            }
        }
    }
    
    
    
    
    
    
    //리플 등록 클릭
    @IBAction func replyInsertAction(_ sender: AnyObject) {
        if spin.isHidden == false{
            return
        }
        spin.isHidden = false
        spin.startAnimating()
        
        if !Storage.isRealmUser(){
            self.webView.stringByEvaluatingJavaScript(from: "\(self.replyFn)")
            self.spin.isHidden = true
            self.spin.stopAnimating()
            Util.alert(self, message: "리플등록은 로그인을 하셔야 가능합니다.")
        }else{
            if (replyInsertField.text?.characters.count)! < 1{
                self.webView.stringByEvaluatingJavaScript(from: "\(self.replyFn)")
                self.spin.isHidden = true
                self.spin.stopAnimating()
            }else{
                let user = Storage.getRealmUser()
                let parameters : [String: AnyObject] = ["seq": courtSeq as AnyObject, "context": replyInsertField.text! as AnyObject, "id": user.userId as AnyObject]
                self.replyInsertField.text = ""
                URLReq.request(self, url: URLReq.apiServer+URLReq.api_court_replyInsert, param: parameters, callback: { (dic) in
                    self.webView.stringByEvaluatingJavaScript(from: "\(self.replyFn)")
                    self.spin.isHidden = true
                    self.spin.stopAnimating()
                })
            }
        }
    }
    
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //웹뷰 가져옴
    func webViewDidFinishLoad(_ webView: UIWebView) {
        replySpin.stopAnimating()
        replySpin.isHidden = true
    }
    
    //키보드 생김/사라짐 셀렉터
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! TabBar).navVC = self.navigationController
    }
    //view 사라지기 전 작동
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    //키보드생길때
    func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentSize.height = self.scrollViewHeight + keyboardSize.height
        }
    }
    //키보드없어질때
    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentSize.height = self.scrollViewHeight
    }
    
    
    //인풋창 끝나면 키보드 없애기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    //인풋창 Done가 들어오면 키보드 없애기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
