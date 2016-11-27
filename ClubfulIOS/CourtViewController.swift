//
//  CourtViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit


//임시 데이터
var tempData2 : [[String: AnyObject]] = [
    [
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],[
        "seq":1 as AnyObject,
        "context":"댓글입니다 댓글입니다 댓글" as AnyObject,
        "nickName":"가나다" as AnyObject,
        "date":"2016-09-21" as AnyObject
    ],
]


class CourtViewController : UIViewController{
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
    
    //리플
    @IBOutlet var replyTableView: UITableView!
    var replyArray = [Reply]()
    
    
    //이미지 URL 저장
    var imageURLList = [String]()
    //이미지 리스트 저장
    var imageViewList = [UIImageView]()
    //이미지 하단 네비 저장
    var imageBottomIndex : [UIView] = []
    
    
    var court : Court!
    var imageScrollIdx = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.keyboardHide(_:))))
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                self.scrollViewHeight = self.scrollView.frame.height
            }
        }
        
        self.spin.isHidden = true
        self.imageSpin.isHidden = false
        self.replySpin.isHidden = true
        self.spin.stopAnimating()
        self.imageSpin.startAnimating()
        self.replySpin.startAnimating()
        self.imageSlide.delegate = self
        self.replyInsertField.delegate = self
        self.replyTableView.delegate = self
        self.replyTableView.dataSource = self
        self.replyTableView.rowHeight = UITableViewAutomaticDimension
        self.replyTableView.estimatedRowHeight = 20
        self.replyTableView.separatorStyle = .none
        //슬라이드 효과
        self.imageSlide.isPagingEnabled = true
        self.imageSlide.showsVerticalScrollIndicator = false
        self.imageSlide.showsHorizontalScrollIndicator = false
        
        var parameters : [String: AnyObject] = [:]
        parameters.updateValue(self.courtSeq as AnyObject, forKey: "seq")
        URLReq.request(self, url: URLReq.apiServer+URLReq.api_court_detail, param: parameters, callback: { (dic) in
            if let data = dic["result"] as? [String: AnyObject]{
                self.court = Court(data)
                self.setLayout()
            }
        })
        self.interest()
        self.addReply()
    }
    
    func interest(){
        let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
        var starImage = "ic_star_on"
        if courtStar == nil{
            starImage = "ic_star_off"
        }
        self.interestBtn.setImage(UIImage(named: starImage), for: UIControlState())
    }
    
    func setLayout(){
        self.interestLbl.text = "\(self.court.interest!)"
        self.descTextView.text = self.court.description
        self.headerLbl.text = "\(self.court.cname!) (\(self.court.categoryName!))"
        descTextView.scrollToTop()
        
        DispatchQueue.global().async {
            for image in self.court.imageList{
                if let imageUrl = Foundation.URL(string: image["image"]!){
                    if let imageData = try? Data(contentsOf: imageUrl){
                        if let imageUI = UIImage(data: imageData){
                            let imgView = UIImageView(image: imageUI)
                            self.imageURLList.append(image["image"]!)
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
                imageSource.frame = CGRect(x: self.imageSlide.frame.width*idx, y: 0, width: self.imageSlide.frame.width, height: self.imageSlide.frame.height)
                imageSource.contentMode = .scaleAspectFit
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
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async{
                ///////////
                //통신//
                /////////
                self.replySpin.stopAnimating()
                self.replySpin.isHidden = true
                for data in tempData2{
                    self.replyArray.append(Reply(data))
                }
                self.replyTableView.reloadData()
            }
        }
    }
    
    //gcm 클릭
    @IBAction func gcmPushAction(_ sender: AnyObject) {
        print("gcm")
    }
    
    //약도보기 클릭
    @IBAction func courtMapAction(_ sender: AnyObject) {
        let sname : String = "내위치".queryValue()
        let sx : Double = Storage.latitude
        let sy : Double = Storage.longitude
        let ename : String = court.addressShort.queryValue()
        let ex : Double = court.latitude
        let ey : Double = court.longitude
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
    
    
    //리플 등록 클릭
    @IBAction func replyInsertAction(_ sender: AnyObject) {
        replyInsertAction()
    }
    
    func replyInsertAction(){
        if replySpin.isHidden == false{
            return
        }
        replySpin.isHidden = false
        replySpin.startAnimating()
        
        if !Storage.isRealmUser(){
            self.replySpin.isHidden = true
            self.replySpin.stopAnimating()
            Util.alert(self, message: "리플등록은 로그인을 하셔야 가능합니다.")
        }else{
            if (replyInsertField.text?.characters.count)! < 1{
                self.replySpin.isHidden = true
                self.replySpin.stopAnimating()
            }else{
                let user = Storage.getRealmUser()
                let parameters : [String: AnyObject] = ["seq": courtSeq as AnyObject, "context": replyInsertField.text! as AnyObject, "id": user.userId as AnyObject]
                self.replyInsertField.text = ""
                URLReq.request(self, url: URLReq.apiServer+URLReq.api_court_replyInsert, param: parameters, callback: { (dic) in
                    self.replySpin.isHidden = true
                    self.replySpin.stopAnimating()
                })
            }
        }

    }
    
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
}




extension CourtViewController{
    //키보드 생김/사라짐 셀렉터
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        ((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController as! TabBar).navVC = self.navigationController
    }
}


extension CourtViewController : UITextFieldDelegate{
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
    //뷰 클릭했을때
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.replyInsertField {
            self.replyInsertAction()
            return false
        }
        return true
    }
}

extension CourtViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replyArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reply = self.replyArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReplyCell", for: indexPath) as! ReplyCell
        cell.setReply(reply)
        return cell
    }
}

extension CourtViewController : UITableViewDelegate{
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
        }else if scrollView == self.replyTableView{
            let currentOffset = self.replyTableView.contentOffset.y
            let maximumOffset = self.replyTableView.contentSize.height - self.replyTableView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 && self.spin.isHidden == true{
                self.addReply()
            }
        }
    }
}
