//
//  MypageViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController, UIScrollViewDelegate {
    let interactor = Interactor()
    
    
    @IBOutlet var interestCourt: UIScrollView!
    @IBOutlet var createCourt: UIScrollView!
    @IBOutlet var interestSpin: UIActivityIndicatorView!
    @IBOutlet var createSpin: UIActivityIndicatorView!
    
    
    
    var courtInterestListData = [[String: AnyObject]]()
    var courtCreateListData = [[String: AnyObject]]()
    
    
    //이미지 URL 저장
    var imageURLList1 = [String]()
    var imageURLList2 = [String]()
    //이미지 리스트 저장
    var imageList1 = [UIImage]()
    var imageList2 = [UIImage]()
    
    var nonUserView : NonUserView!
    
    var courtSeq: Int!
    
    override func viewWillAppear(_ animated: Bool) {
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
        let user = Storage.getRealmUser()
        if user.isLogin != -1{
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
            let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "userId": user.userId as AnyObject]
            URL.request(self, url: URL.apiServer+URL.api_user_mypage, param: parameters, callback: { (dic) in
                if let interestList = dic["interestList"] as? [[String: AnyObject]]{
                    DispatchQueue.global().async {
                        self.interestData(interestList)
                    }
                }
                if let myCourtInsertList = dic["myCourtInsert"] as? [[String: AnyObject]]{
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
    
    
    
    
    //실제 레이아웃 만들기
    
    //찜한 코트 레이아웃
    func setInterestImageLayout(){
        DispatchQueue.main.async {
            self.interestCourt.subviews.forEach({$0.removeFromSuperview()})
            self.interestSpin.startAnimating()
            self.interestSpin.isHidden = false
            
            var i : CGFloat = 0
            for obj in self.courtInterestListData{
                if let imgUI = obj["image"] as? UIImage{
                    let imgBtn = UIButton(frame: CGRect(x: self.interestCourt.frame.width * i, y: 0, width: self.interestCourt.frame.width, height: self.interestCourt.frame.height-40))
                    imgBtn.addAction(.allTouchEvents){
                        imgBtn.isHighlighted = false
                    }
                    imgBtn.addAction(.touchUpInside){
                        if let seq = obj["seq"] as? Int{
                            self.courtSeq = seq
                            self.performSegue(withIdentifier: "mypage_courtDetail", sender: nil)
                        }
                    }
                    self.interestCourt.addSubview(imgBtn)
                    
                    let imgView = UIImageView(frame: self.calLayoutRate(fullSize: imgBtn.frame.size, imageSize: imgUI.size))
                    imgView.image = imgUI
                    imgBtn.addSubview(imgView)
                }
                
                let infoStr = "\(obj["cname"]!) (\(obj["categoryName"]!) / \(obj["address"]!))"
                let objLbl = UILabel(frame: CGRect(x: self.interestCourt.frame.width * i + 10, y: self.interestCourt.frame.height-40, width: self.interestCourt.frame.width-10, height: 40))
                objLbl.text = "\(infoStr)"
                objLbl.font = UIFont(name: (objLbl.font?.fontName)!, size: 12)
                self.interestCourt.addSubview(objLbl)
                
                i += 1
            }
            //scrollView 총 넓이
            self.interestCourt.contentSize = CGSize(width: self.interestCourt.frame.size.width*CGFloat(i) ,height: self.interestCourt.frame.size.height)
            
            self.interestSpin.stopAnimating()
            self.interestSpin.isHidden = true
            self.interestCourt.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    //내가등록한 코트 레이아웃
    func setMyCreateImageLayout(){
        DispatchQueue.main.async {
            self.createCourt.subviews.forEach({$0.removeFromSuperview()})
            self.createSpin.startAnimating()
            self.createSpin.isHidden = false
            
            var i : CGFloat = 0
            for obj in self.courtCreateListData{
                
                if let imgUI = obj["image"] as? UIImage{
                    let imgBtn = UIButton(frame: CGRect(x: self.createCourt.frame.width * i, y: 0, width: self.createCourt.frame.width, height: self.createCourt.frame.height-40))
                    imgBtn.addAction(.allTouchEvents){
                        imgBtn.isHighlighted = false
                    }
                    imgBtn.addAction(.touchUpInside){
                        if let seq = obj["seq"] as? Int{
                            self.courtSeq = seq
                            self.performSegue(withIdentifier: "mypage_courtDetail", sender: nil)
                        }
                    }
                    self.createCourt.addSubview(imgBtn)
                    
                    let imgView = UIImageView(frame: self.calLayoutRate(fullSize: imgBtn.frame.size, imageSize: imgUI.size))
                    imgView.image = imgUI
                    imgBtn.addSubview(imgView)
                }
                
                let infoStr = "\(obj["cname"]!) (\(obj["categoryName"]!) / \(obj["address"]!))"
                let objLbl = UILabel(frame: CGRect(x: self.createCourt.frame.width * i + 10, y: self.createCourt.frame.height-40, width: self.createCourt.frame.width-10, height: 40))
                objLbl.text = "\(infoStr)"
                objLbl.font = UIFont(name: (objLbl.font?.fontName)!, size: 12)
                self.createCourt.addSubview(objLbl)
                
                i += 1
            }
            
            //scrollView 총 넓이
            self.createCourt.contentSize = CGSize(width: self.createCourt.frame.size.width*CGFloat(i) ,height: self.createCourt.frame.size.height)
            
            self.createSpin.stopAnimating()
            self.createSpin.isHidden = true
            self.createCourt.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    // 데이터 만들기
    
    //찜한 코트 리스트 데이터 만들기
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
                                    self.courtInterestListData = tmpList
                                    setInterestImageLayout()
                                    //길게클릭
                                    self.interestCourt.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed1(_:))))
                                    self.interestCourt.isUserInteractionEnabled = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    //내가 등록한 코트 리스트 데이터 만들기
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
                                    self.courtCreateListData = tmpList
                                    setMyCreateImageLayout()
                                    //길게클릭
                                    self.createCourt.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed2(_:))))
                                    self.createCourt.isUserInteractionEnabled = true
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CourtViewController{
            vc.courtSeq = self.courtSeq
        }else if let vc = segue.destination as? MessageViewController{
            vc.transitioningDelegate = self
            vc.interactor = interactor
        }
    }
}


extension MypageViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator(direction: .right)
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

