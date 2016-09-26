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
    
    //이미지 URL 저장
    var imageURLList1 = [String]()
    var imageURLList2 = [String]()
    //이미지 리스트 저장
    var imageList1 = [UIImage]()
    var imageList2 = [UIImage]()
    
    var nonUserView : NonUserView!
    override func viewWillAppear(_ animated: Bool) {
        print("MypageViewController viewWillAppear")
        if nonUserView == nil{
            if let customView = Bundle.main.loadNibNamed("NonUserView", owner: self, options: nil)?.first as? NonUserView {
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
        interestCourt.isPagingEnabled = true
        createCourt.isPagingEnabled = true
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
            let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "userId": user.userId as AnyObject]
            URL.request(self, url: URL.apiServer+URL.api_user_mypage, param: parameters, callback: { (dic) in
                if let interestList = dic["interestList"] as? [[String: AnyObject]]{
                    var interestCnt = interestList.count
                    if interestCnt == 0{
                        interestCnt = 1
                    }
                    //scrollView 총 넓이
                    self.interestCourt.contentSize = CGSize(width: self.interestCourt.frame.size.width*CGFloat(interestCnt) ,height: self.interestCourt.frame.size.height)
                    DispatchQueue.global().async {
                        self.interestData(interestList)
                    }
                }
                if let myCourtInsertList = dic["myCourtInsert"] as? [[String: AnyObject]]{
                    var myInsertCnt = myCourtInsertList.count
                    if myInsertCnt == 0{
                        myInsertCnt = 1
                    }
                    //scrollView 총 넓이
                    self.createCourt.contentSize = CGSize(width: self.createCourt.frame.size.width*CGFloat(myInsertCnt) ,height: self.createCourt.frame.size.height)
                    DispatchQueue.global().async{
                        self.myInsertData(myCourtInsertList)
                    }
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
    
    //찜한 코트
    func setInterestImageLayout(_ tmpList : [[String: AnyObject]], courtInfo: UIScrollView){
        DispatchQueue.main.async {
            var i : CGFloat = 0
            for obj in tmpList{
                if let imgUI = obj["image"] as? UIImage{
                    let imgBtn = UIButton(frame: CGRect(x: courtInfo.frame.width * i, y: 0, width: courtInfo.frame.width, height: courtInfo.frame.height-40))
                    imgBtn.addAction(.allTouchEvents){
                        imgBtn.isHighlighted = false
                    }
                    imgBtn.addAction(.touchUpInside){
                        if let seq = obj["seq"] as? Int{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let uvc = storyBoard.instantiateViewController(withIdentifier: "courtVC")
                            (uvc as! CourtViewController).courtSeq = seq
                            uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                            self.present(uvc, animated: true, completion: nil)
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
            //길게클릭
            courtInfo.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed1(_:))))
            courtInfo.isUserInteractionEnabled = true
            
            self.interestSpin.stopAnimating()
            self.interestSpin.isHidden = true
        }
    }
    
    //내가등록한 코트
    func setMyInsertImageLayout(_ tmpList : [[String: AnyObject]], courtInfo: UIScrollView){
        DispatchQueue.main.async {
            var i : CGFloat = 0
            for obj in tmpList{
                
                if let imgUI = obj["image"] as? UIImage{
                    let imgBtn = UIButton(frame: CGRect(x: courtInfo.frame.width * i, y: 0, width: courtInfo.frame.width, height: courtInfo.frame.height-40))
                    imgBtn.addAction(.allTouchEvents){
                        imgBtn.isHighlighted = false
                    }
                    imgBtn.addAction(.touchUpInside){
                        if let seq = obj["seq"] as? Int{
                            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                            let uvc = storyBoard.instantiateViewController(withIdentifier: "courtVC")
                            (uvc as! CourtViewController).courtSeq = seq
                            uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                            self.present(uvc, animated: true, completion: nil)
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
            //길게클릭
            courtInfo.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed2(_:))))
            courtInfo.isUserInteractionEnabled = true
            
            self.createSpin.stopAnimating()
            self.createSpin.isHidden = true
        }
    }
    
    
    
    
    
    
    
    
    //찜한 코트 리스트
    func interestData(_ list: [[String: AnyObject]]){
        if list.count == 0{
            let noneLbl = UILabel(frame: CGRect(x: 0, y: 0, width: interestCourt.frame.width, height: interestCourt.frame.height))
            noneLbl.text = "찜한 코트가 없습니다."
            noneLbl.textAlignment = .center
            noneLbl.font = UIFont(name: (noneLbl.font?.fontName)!, size: 20)
            DispatchQueue.main.async {
                self.interestCourt.addSubview(noneLbl)
            }
        }else{
            var i : CGFloat = 0
            var tmpList = [[String: AnyObject]]()
            imageURLList1 = []
            imageList1 = []
            for obj in list{
                var tmpObj = [String: AnyObject]()
                if let img = obj["image"] as? String{
                    if let imgURL = Foundation.URL(string: img){
                        if let imgData = try? Data(contentsOf: imgURL){
                            if let imgUI = UIImage(data: imgData){
                                imageURLList1.append(img)
                                imageList1.append(imgUI)
                                tmpObj["image"] = imgUI
                                
                                if let addressText = obj["address"] as? String{
                                    tmpObj["address"] = addressText as AnyObject?
                                }
                                if let addressText = obj["addressShort"] as? String{
                                    tmpObj["addressShort"] = addressText as AnyObject?
                                }
                                if let categoryName = obj["categoryName"] as? String{
                                    tmpObj["categoryName"] = categoryName as AnyObject?
                                }
                                if let cname = obj["cname"] as? String{
                                    tmpObj["cname"] = cname as AnyObject?
                                }
                                if let seq = obj["seq"] as? Int{
                                    tmpObj["seq"] = seq as AnyObject?
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
    func myInsertData(_ list: [[String: AnyObject]]){
        if list.count == 0{
            let noneLbl = UILabel(frame: CGRect(x: 0, y: 0, width: createCourt.frame.width, height: createCourt.frame.height))
            noneLbl.text = "찜한 코트가 없습니다."
            noneLbl.textAlignment = .center
            noneLbl.font = UIFont(name: (noneLbl.font?.fontName)!, size: 20)
            DispatchQueue.main.async {
                self.createCourt.addSubview(noneLbl)
            }
        }else{
            var i : CGFloat = 0
            var tmpList = [[String: AnyObject]]()
            imageURLList2 = []
            imageList2 = []
            for obj in list{
                var tmpObj = [String: AnyObject]()
                if let img = obj["image"] as? String{
                    if let imgURL = Foundation.URL(string: img){
                        if let imgData = try? Data(contentsOf: imgURL){
                            if let imgUI = UIImage(data: imgData){
                                imageURLList2.append(img)
                                imageList2.append(imgUI)
                                tmpObj["image"] = imgUI
                                
                                if let addressText = obj["address"] as? String{
                                    tmpObj["address"] = addressText as AnyObject?
                                }
                                if let addressText = obj["addressShort"] as? String{
                                    tmpObj["addressShort"] = addressText as AnyObject?
                                }
                                if let categoryName = obj["categoryName"] as? String{
                                    tmpObj["categoryName"] = categoryName as AnyObject?
                                }
                                if let cname = obj["cname"] as? String{
                                    tmpObj["cname"] = cname as AnyObject?
                                }
                                if let seq = obj["seq"] as? Int{
                                    tmpObj["seq"] = seq as AnyObject?
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
    
    
    
    func longPressed1(_ sender: UILongPressGestureRecognizer){
        if sender.state == .ended {
            //Do Whatever You want on End of Gesture
        }else if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            Util.imageSaveHandler(self, imageUrl: "\(self.imageURLList1[self.idx1])", image: self.imageList1[self.idx1])
        }
    }
    func longPressed2(_ sender: UILongPressGestureRecognizer){
        if sender.state == .ended {
            //Do Whatever You want on End of Gesture
        }else if sender.state == .began {
            //Do Whatever You want on Began of Gesture
            Util.imageSaveHandler(self, imageUrl: "\(self.imageURLList2[self.idx2])", image: self.imageList2[self.idx2])
        }
    }
    
    
    
    var idx1 = 0
    var idx2 = 0
    //스크롤뷰 슬라이더 딜리게이트
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = Double(scrollView.bounds.size.width)
        let offset = Double(scrollView.contentOffset.x)
        let idx = Int(offset/width)
        if scrollView == interestCourt{
            if self.idx1 != idx{
                self.idx1 = idx
                
            }
        }else if scrollView == createCourt{
            if self.idx2 != idx{
                self.idx2 = idx
                
            }
        }
        
    }
    
    
    //개인정보 수정 클릭
    @IBAction func userConvertAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "userConvertVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
    
    //쪽지함 클릭
    @IBAction func messageAction(_ sender: AnyObject) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let uvc = storyBoard.instantiateViewController(withIdentifier: "messageVC")
        uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        self.present(uvc, animated: true, completion: nil)
    }
}
