//
//  CourtViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtViewController : UIViewController, UITextFieldDelegate, UIScrollViewDelegate{
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
    
    //리플 스크롤뷰
    @IBOutlet var replyScrollView: UIScrollView!
    
    
    
    //이미지 URL 저장
    var imageURLList = [String]()
    //이미지 리스트 저장
    var imageViewList = [UIImageView]()
    //이미지 하단 네비 저장
    var imageBottomIndex : [UIView] = []
    
    
    var court : [String: AnyObject]!
    
    
    
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
        replyScrollView.delegate = self
        //슬라이드 효과
        imageSlide.isPagingEnabled = true
        imageSlide.showsVerticalScrollIndicator = false
        imageSlide.showsHorizontalScrollIndicator = false
        
        
        let parameters : [String: AnyObject] = ["seq": self.courtSeq as AnyObject]
        URLReq.request(self, url: URLReq.apiServer+URLReq.api_court_detail, param: parameters, callback: { (dic) in
            if let courtTmp = dic["result"] as? [String: AnyObject]{
                self.court = courtTmp
                self.interestLbl.text = "\(self.court["interest"]!)"
                self.descTextView.text = "\(self.court["description"]!)"
                self.headerLbl.text = "\(self.court["cname"]!) (\(self.court["categoryName"]!))"
                
                DispatchQueue.global().async {
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
        self.replySpin.isHidden = true
        addReply()
        
        
        descTextView.scrollToTop()
        replyInsertField.delegate = self
        
        let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
        var starImage = "ic_star_on"
        if courtStar == nil{
            starImage = "ic_star_off"
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
            Util.imageSaveHandler(self, imageUrl: "\(self.imageURLList[self.imageScrollIdx])", image: self.imageViewList[self.imageScrollIdx].image!)
        }
    }
    
    
    
    
    
    
    
    var imageScrollIdx = 0
    //스크롤뷰 슬라이더 딜리게이트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.imageSlide {
            let width = Double(scrollView.bounds.size.width)
            let offset = Double(scrollView.contentOffset.x)
            let idx = Int(offset/width)
            if self.imageScrollIdx != idx{
                self.imageScrollIdx = idx
                self.imageBottomIndex.forEach({ (__) in
                    __.backgroundColor = UIColor.black
                })
                self.imageBottomIndex[idx].backgroundColor = Util.commonColor
            }
        }else if scrollView == self.replyScrollView{
            let currentOffset = self.replyScrollView.contentOffset.y
            let maximumOffset = self.replyScrollView.contentSize.height - self.replyScrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 && self.replySpin.isHidden == true{
                self.addReply()
            }
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
            var starImage = "ic_star_off"
            if courtStar == nil{
                starImage = "ic_star_on"
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
    
    
    
    //reply Api
    var replyTotalRow : Int!
    var replyPage = 1
    var replyIdx: CGFloat = 0
    func addReply(){
        if replyTotalRow != nil && self.replyTotalRow <= Int(self.replyIdx){
            self.replySpin.isHidden = true
            self.replySpin.stopAnimating()
            return
        }
        if self.replySpin.isHidden == false{
            return
        }
        self.replySpin.startAnimating()
        self.replySpin.isHidden = false
        let replyElementSize: CGFloat = 20
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            DispatchQueue.main.async{
                ///////////
                //통신//
                /////////
                self.replySpin.stopAnimating()
                self.replySpin.isHidden = true
                for _ in 0...10{
                    let replyElementView = UIView(frame: CGRect(x: 0, y: self.replyIdx * replyElementSize, width: self.replyScrollView.frame.size.width, height: replyElementSize))
                    
                    let msgLbl = UILabel(frame: CGRect(x: 0, y: 0, width: replyElementView.frame.width/5*3, height: replyElementView.frame.height))
                    msgLbl.font = UIFont(name: msgLbl.font.fontName, size: 11)
                    msgLbl.text = "와 여기 좋은데요~~~~"
                    
                    let nickLbl = UILabel(frame: CGRect(x: replyElementView.frame.width/5*3, y: 0, width: replyElementView.frame.width/5, height: replyElementView.frame.height))
                    nickLbl.font = UIFont(name: nickLbl.font.fontName, size: 11)
                    nickLbl.text = "가나다\(self.replyIdx)"
                    
                    let dateLbl = UILabel(frame: CGRect(x: replyElementView.frame.width/5*4, y: 0, width: replyElementView.frame.width/5, height: replyElementView.frame.height))
                    dateLbl.font = UIFont(name: dateLbl.font.fontName, size: 11)
                    dateLbl.text = "2016-09-21"
                    dateLbl.textAlignment = .right
                    
                    replyElementView.addSubview(msgLbl)
                    replyElementView.addSubview(nickLbl)
                    replyElementView.addSubview(dateLbl)
                    
                    self.replyIdx += 1
                    self.replyScrollView.addSubview(replyElementView)
                }
                self.replyScrollView.contentSize.height = self.replyIdx*replyElementSize
            }
        }
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
            self.spin.isHidden = true
            self.spin.stopAnimating()
            Util.alert(self, message: "리플등록은 로그인을 하셔야 가능합니다.")
        }else{
            if (replyInsertField.text?.characters.count)! < 1{
                self.spin.isHidden = true
                self.spin.stopAnimating()
            }else{
                let user = Storage.getRealmUser()
                let parameters : [String: AnyObject] = ["seq": courtSeq as AnyObject, "context": replyInsertField.text! as AnyObject, "id": user.userId as AnyObject]
                self.replyInsertField.text = ""
                URLReq.request(self, url: URLReq.apiServer+URLReq.api_court_replyInsert, param: parameters, callback: { (dic) in
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
