//
//  MypageViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController {
    @IBOutlet var interestCourt: UIScrollView!
    @IBOutlet var createCourt: UIScrollView!
    @IBOutlet var interestSpin: UIActivityIndicatorView!
    @IBOutlet var createSpin: UIActivityIndicatorView!
    var interestArray = [Court]()
    var createArray = [Court]()
    var nonUserView : NonUserView!
    var courtSeq: Int!
    static var isReload = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        //슬라이드 효과
        interestCourt.isPagingEnabled = true
        createCourt.isPagingEnabled = true
        interestCourt.showsVerticalScrollIndicator = false
        createCourt.showsVerticalScrollIndicator = false
        interestCourt.showsHorizontalScrollIndicator = false
        createCourt.showsHorizontalScrollIndicator = false
    }
    
    func reloadData(){
        let user = Storage.getRealmUser()
        let parameters : [String: AnyObject] = ["userId": user.userId as AnyObject]
        URLReq.request(self, url: URLReq.apiServer+URLReq.api_user_mypage, param: parameters, callback: { (dic) in
            DispatchQueue.global().async {
                if let list = dic["interestList"] as? [[String: AnyObject]]{
                    self.setData(list, type: 0)
                }
                if let list = dic["myCourtInsert"] as? [[String: AnyObject]]{
                    self.setData(list, type: 1)
                }
            }
        })
    }
    
    func layout(){
        if Storage.isRealmUser(){
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
            if MypageViewController.isReload{
                MypageViewController.isReload = false
                self.reloadData()
            }
        }else{
            self.view.subviews.forEach({ (tempView) in
                if tempView == nonUserView{
                    tempView.removeFromSuperview()
                }
            })
            self.view.addSubview(nonUserView)
        }
    }
    
    
    
    func setData(_ list: [[String: AnyObject]], type: Int){
        func noneLbl(){
            let noneLbl = UILabel(frame: CGRect(x: 0, y: 0, width: interestCourt.frame.width, height: interestCourt.frame.height))
            if type == 0{
                noneLbl.text = "찜한 코트가 없습니다."
            }else if type == 1{
                noneLbl.text = "내가 등록한 코트가 없습니다."
            }
            noneLbl.textAlignment = .center
            noneLbl.font = UIFont(name: (noneLbl.font?.fontName)!, size: 20)
            DispatchQueue.main.async {
                if type == 0{
                    self.interestCourt.addSubview(noneLbl)
                }else if type == 1{
                    self.createCourt.addSubview(noneLbl)
                }
            }
        }
        DispatchQueue.main.async {
            if type == 0{
                self.interestCourt.subviews.forEach({$0.removeFromSuperview()})
                self.interestCourt.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                self.interestSpin.startAnimating()
                self.interestSpin.isHidden = false
            }else if type == 1{
                self.createCourt.subviews.forEach({$0.removeFromSuperview()})
                self.createCourt.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
                self.createSpin.startAnimating()
                self.createSpin.isHidden = false
            }
        }
        
        if list.count == 0{
            noneLbl()
        }else{
            if type == 0{
                self.interestArray = []
            }else if type == 1{
                self.createArray = []
            }
            for data in list{
                let court = Court(data)
//                if court.setImageData(){
//                    if type == 0{
//                        self.interestArray.append(court)
//                    }else if type == 1{
//                        self.createArray.append(court)
//                    }
//                }
            }
            if type == 0 && self.interestArray.count == 0{
                noneLbl()
            }else if type == 1 && self.createArray.count == 0{
                noneLbl()
            }else{
                DispatchQueue.main.async{
                    if type == 0{
                        self.setImageLayout(self.interestArray, type: type)
                    }else if type == 1{
                        self.setImageLayout(self.createArray, type: type)
                    }
                }
            }
        }
    }
    
    func setImageLayout(_ list: [Court], type: Int){
        var i : CGFloat = 0
        for data in list{
            if let customView = Bundle.main.loadNibNamed("MypageCourtView", owner: self, options: nil)?.first as? MypageCourtView {
                customView.setCourt(data)
                customView.touchCallback = {(court: Court) in
                    self.courtSeq = court.seq
                    self.performSegue(withIdentifier: "mypage_courtDetail", sender: nil)
                }
                customView.pressedCallback = {(court: Court) in
                    //Util.imageSaveHandler(self, imageUrl: court.image, image: court.imageData)
                }
                if type == 0{
                    customView.frame = CGRect(x: i*self.interestCourt.frame.width, y: 0, width: self.interestCourt.frame.width, height: self.interestCourt.frame.height)
                    self.interestCourt.addSubview(customView)
                }else if type == 1{
                    customView.frame = CGRect(x: i*self.createCourt.frame.width, y: 0, width: self.createCourt.frame.width, height: self.createCourt.frame.height)
                    self.createCourt.addSubview(customView)
                }
                i += 1
            }
        }
        if type == 0{
            self.interestCourt.contentSize.width = self.interestCourt.frame.size.width*i
            self.interestSpin.stopAnimating()
            self.interestSpin.isHidden = true
        }else if type == 1{
            self.createCourt.contentSize.width = self.createCourt.frame.size.width*i
            self.createSpin.stopAnimating()
            self.createSpin.isHidden = true
        }
    }
}

extension MypageViewController{
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CourtViewController{
            vc.courtSeq = self.courtSeq
        }
    }
}
