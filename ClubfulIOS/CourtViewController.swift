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
    ]
]


class CourtViewController : UIViewController{
    var courtSeq : Int!
    
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight : CGFloat = 0
    
    @IBOutlet var headerLbl: UILabel!
    
    @IBOutlet var imageSpin: UIActivityIndicatorView!
    @IBOutlet var replySpin: UIActivityIndicatorView!
    @IBOutlet var spin: UIActivityIndicatorView!
    
    @IBOutlet var interestBtn: UIButton!
    @IBOutlet var interestLbl: UILabel!
    
    @IBOutlet var imageView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var descTextView: UITextView!
    @IBOutlet var replyTableView: UITableView!
    
    var courtTextView: CourtTextView?
    
    var replyArray = [Reply]()
    var imageArray = [(String, Data?)]()
    var imageBottomIndex : [Oval] = []
    
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
        
        self.spin.stopAnimating()
        self.imageSpin.startAnimating()
        self.replySpin.startAnimating()
        
        self.courtTextView = Bundle.main.loadNibNamed("CourtTextView", owner: self, options: nil)?.first as? CourtTextView
        self.courtTextView?.delegate = self
        self.courtTextView?.load()
        
        DispatchQueue.global().async {
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(self.courtSeq as AnyObject, forKey: "seq")
            URLReq.request(self, url: URLReq.apiServer+"court/detail", param: parameters, callback: { (dic) in
                if let data = dic["result"] as? [String: AnyObject]{
                    self.court = Court(data)
                    Thread.sleep(forTimeInterval: 0.1)
                    DispatchQueue.main.async {
                        self.setLayout()
                    }
                }
            })
            Thread.sleep(forTimeInterval: 0.1)
            DispatchQueue.main.async {
                self.interest()
                self.addReply()
            }
        }
    }
    
    
    
    
    
    func setLayout(){
        self.interestLbl.text = "\(self.court.interest!)"
        self.descTextView.text = self.court.description
        self.headerLbl.text = "\(self.court.cname!) (\(self.court.categoryName!))"
        descTextView.scrollToTop()
        
        func addOvalView(){
            let ovalView = Oval(size: 10)
            self.imageBottomIndex.append(ovalView)
            self.setImages()
        }
        func appendImage(_ imageData: Data!, _ imageStr: String){
            if !(imageData == nil || imageData.count == 0){
                self.imageArray.append((imageStr, imageData!))
            }
        }
        
        DispatchQueue.global().async {
            self.court.setImage1Data(){
                appendImage(self.court.imageData1, self.court.image1)
                addOvalView()
            }
            self.court.setImage2Data(){
                appendImage(self.court.imageData2, self.court.image2)
                addOvalView()
            }
            self.court.setImage3Data(){
                appendImage(self.court.imageData3, self.court.image3)
                addOvalView()
            }
            self.court.setImage4Data(){
                appendImage(self.court.imageData4, self.court.image4)
                addOvalView()
            }
            self.court.setImage5Data(){
                appendImage(self.court.imageData5, self.court.image5)
                addOvalView()
            }
            self.court.setImage6Data(){
                appendImage(self.court.imageData6, self.court.image6)
                addOvalView()
            }
        }
    }
    
    
    func setImages(){
        DispatchQueue.main.async {
            self.imageSpin.startAnimating()
            self.imageSpin.isHidden = false
            self.imageView.subviews.forEach({ (v) in
                if let view = v as? Oval{
                    view.removeFromSuperview()
                }
            })
            self.collectionView.reloadData()
            //이미지 하단 네비
            let ovalSize: CGFloat = 10
            let ovalMargin: CGFloat = 10
            let firstX = (self.imageView.frame.width - CGFloat(self.imageArray.count)*(ovalSize+ovalMargin))/2
            var i = 0
            for ovalView in self.imageBottomIndex{
                ovalView.frame.origin = CGPoint(x: firstX+(ovalMargin)/2+(ovalSize+ovalMargin) * CGFloat(i), y: self.imageView.frame.height-ovalSize)
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
    
    func interest(){
        let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
        var starImage = "ic_star_on"
        if courtStar == nil{
            starImage = "ic_star_off"
        }
        self.interestBtn.setImage(UIImage(named: starImage), for: UIControlState())
    }
    
    //관심 클릭
    @IBAction func interestAction(_ sender: AnyObject) {
        if spin.isHidden == false{
            return
        }
        spin.isHidden = false
        spin.startAnimating()
        
        let courtStar = Storage.getStorage("courtStar_\(self.courtSeq)")
        var type = "N"
        if courtStar == nil{
            type = "Y"
        }
        var parameters : [String: AnyObject] = [:]
        parameters.updateValue(self.courtSeq as AnyObject, forKey: "seq")
        parameters.updateValue(type as AnyObject, forKey: "type")
        
        URLReq.request(self, url: URLReq.apiServer+"court/interest", param: parameters, callback: { (dic) in
            self.spin.isHidden = true
            self.spin.stopAnimating()
            var starImage = "ic_star_off"
            if courtStar == nil{
                starImage = "ic_star_on"
                Storage.setStorage("courtStar_\(self.courtSeq)", value: true as AnyObject)
            }else{
                Storage.removeStorage("courtStar_\(self.courtSeq)")
            }
            MypageInsViewController.isReload = true
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
        let sname : String = "내위치".queryValue()
        let sx : Double = Storage.latitude
        let sy : Double = Storage.longitude
        let ename : String = court.addressShort.queryValue()
        let ex : Double = court.latitude
        let ey : Double = court.longitude
        let simplemapUrl = "https://m.map.naver.com/route.nhn?menu=route&sname=\(sname)&sx=\(sx)&sy=\(sy)&ename=\(ename)&ex=\(ex)&ey=\(ey)&pathType=1&showMap=true#/publicTransit/list/\(sname),\(sy),\(sx),,,true,/\(ename),\(ey),\(ex),,,false,/0"
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
                self.replySpin.stopAnimating()
                self.replySpin.isHidden = true
                for data in tempData2{
                    self.replyArray.append(Reply(data))
                }
                self.replyTableView.reloadData()
            }
        }
    }
    
    //뒤로가기
    @IBAction func backAction(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    class Oval: UIView {
        init(size: CGFloat) {
            super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
            self.frame.size = CGSize(width: size, height: size)
            self.layer.cornerRadius = size/2
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
}




extension CourtViewController{
    //키보드 생김/사라짐 셀렉터
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
            self.courtTextView?.frame.origin.y = self.view.frame.height-50-keyboardSize.height
        }
    }
    //키보드없어질때
    func keyboardWillHide(_ notification: Notification) {
        scrollView.contentSize.height = self.scrollViewHeight
        self.courtTextView?.frame.origin.y = self.view.frame.height-100
    }
    //뷰 클릭했을때
    func keyboardHide(_ sender: AnyObject){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.courtTextView?.textField {
            self.courtTextView?.replyInsertAction("" as AnyObject)
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
        if scrollView == self.collectionView {
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

extension CourtViewController: UICollectionViewDelegate{
    
}

extension CourtViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: self.collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CourtViewCell", for: indexPath) as! CourtViewCell
        let court = self.imageArray[indexPath.row]
        cell.img.frame.size.width = cell.frame.width
        cell.img.image = UIImage(data: court.1!)
        cell.imgTuple = court
        cell.delegate = self
        
        return cell
    }
}

extension CourtViewController: CourtViewCellDelgate{
    func courtViewDoubleTap() {
        self.interestAction("" as AnyObject)
    }
    func courtViewLongGesture(_ imgTuple: (String, Data?)) {
        Util.imageSaveHandler(self, imageUrl: imgTuple.0, image: UIImage(data: imgTuple.1!)!)
    }
}


extension CourtViewController: CourtTextViewDelegate{
    func courtTextLoad() {
        self.courtTextView?.frame = CGRect(x: 0, y: self.view.frame.height-100, width: self.view.frame.width, height: 50)
        self.view.addSubview(self.courtTextView!)
    }
    func courtTextReply(_ textField: UITextField) {
        if replySpin.isHidden == false{
            return
        }
        replySpin.isHidden = false
        replySpin.startAnimating()
        
        if !Storage.isRealmUser(){
            self.replySpin.isHidden = true
            self.replySpin.stopAnimating()
            _ = Util.alert(self, message: "리플등록은 로그인을 하셔야 가능합니다.")
        }else{
            if (textField.text?.characters.count)! < 1{
                self.replySpin.isHidden = true
                self.replySpin.stopAnimating()
            }else{
                let user = Storage.getRealmUser()
                let parameters : [String: AnyObject] = ["seq": courtSeq as AnyObject, "context": textField.text! as AnyObject, "id": user.userId as AnyObject]
                textField.text = ""
                URLReq.request(self, url: URLReq.apiServer+"", param: parameters, callback: { (dic) in
                    self.replySpin.isHidden = true
                    self.replySpin.stopAnimating()
                })
            }
        }
    }
}
