//
//  CourtSearchView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 10. 30..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtSearchView : UIView{
    var ctrl : ViewController!
    @IBOutlet var scrollView: UIScrollView!
    
    func setLayout(_ ctrl: ViewController){
        self.ctrl = ctrl
        
        DispatchQueue.global().async{
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async{
                self.frame = CGRect(x: 0, y: self.ctrl.scrollView.frame.origin.y, width: self.ctrl.view.frame.width/3*2, height: self.ctrl.scrollView.frame.height)
                _ = self.layer(.right, borderWidth: 1, color: UIColor.black)
            }
        }
        ctrl.view.addSubview(self)
    }
    
    
    
    //코트 검색 액션
    func courtSearchAction() {
        if (self.ctrl.searchTextField.text?.characters.count)! >= 2{
            self.ctrl.view.endEditing(true)
            self.scrollView.subviews.forEach({ (v) in
                if let element = v as? CourtSearchElementView{
                    element.removeFromSuperview()
                }
            })
            self.scrollView.scrollToTop()
            //코트 검색 통신
            let user = Storage.getRealmUser()
            let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "address": self.ctrl.searchTextField.text! as AnyObject, "category": user.category as AnyObject, "latitude": user.latitude as AnyObject, "longitude": user.longitude as AnyObject]
            URL.request(self.ctrl, url: URL.apiServer+URL.api_court_listSearch, param: parameters, callback: { (dic) in
                if let list = dic["list"] as? [[String: AnyObject]]{
                    self.ctrl.view.endEditing(true)
                    self.scrollView.subviews.forEach({ (v) in
                        if let element = v as? CourtSearchElementView{
                            element.removeFromSuperview()
                        }
                    })
                    var i : CGFloat = 0
                    let locObjHeight : CGFloat = 90
                    for obj in list{
                        if let customView = Bundle.main.loadNibNamed("CourtSearchElementView", owner: self, options: nil)?.first as? CourtSearchElementView {
                            customView.setLayout(self.ctrl, courtSearchView: self, height: locObjHeight, idx: i, element: obj)
                        }
                        i += 1
                    }
                    self.scrollView.contentSize.height = locObjHeight*i+i+50
                    if self.isHidden != false{
                        self.frame.origin.x = -self.frame.width
                        self.isHidden = false
                        //애니메이션 적용
                        UIView.animate(withDuration: 0.2, animations: {
                            self.frame.origin.x = 0
                            }, completion: {(_) in
                        })
                    }else{
                        self.frame.origin.x = 0
                    }
                }
            })
        }else{
            Util.alert(self.ctrl, message: "검색어는 2글자 이상으로 넣어주세요.")
        }
    }
    
    
    //코트서치 제스처
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        let progress = MenuHelper.calculateProgress(translation, viewBounds: self.bounds, direction: .left)
        if progress > 0{
            if self.frame.origin.x < -self.ctrl.view.frame.width/4{
                //애니메이션 적용
                UIView.animate(withDuration: 0.2, animations: {
                    self.frame.origin.x = -self.frame.width
                    }, completion: {(_) in
                        self.isHidden = true
                        self.frame.origin.x = 0
                })
            }else{
                self.frame.origin.x = -(self.ctrl.view.frame.width/3*2)*progress
            }
        }
    }
}
