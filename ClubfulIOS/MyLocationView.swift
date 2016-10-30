//
//  MainCenterView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MyLocationView : UIView{
    @IBOutlet var scrollView: UIScrollView!
    var scrollViewHeight: CGFloat!
    @IBOutlet var searchTextField: UITextField!
    @IBOutlet var myLocationView: UIView!
    
    var ctrl: ViewController!
    
    func setLayout(_ ctrl: ViewController){
        self.ctrl = ctrl
        
        self.frame = CGRect(x: (ctrl.view.frame.width-300)/2, y: (ctrl.view.frame.height-300)/2, width: 300, height: 300)
        self.searchTextField.borderStyle = .none
        self.searchTextField.delegate = ctrl
        ctrl.view.addSubview(self)
        
        
        self.myLocationView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.myLocationAction)))
    }
    
    func searchAction() {
        if (self.searchTextField.text?.characters.count)! >= 2{
            self.ctrl.view.endEditing(true)
            self.scrollView.subviews.forEach({$0.removeFromSuperview()})
            let user = Storage.getRealmUser()
            //자기위치 검색 통신
            let parameters : [String: AnyObject] = ["token": user.token as AnyObject, "address": self.searchTextField.text! as AnyObject, "language": Util.language as AnyObject]
            URL.request(self.ctrl, url: URL.apiServer+URL.api_location_geocode, param: parameters, callback: { (dic) in
                if let result = dic["results"] as? [String: AnyObject]{
                    if let results = result["results"] as? [[String: AnyObject]]{
                        var i : CGFloat = 0
                        let locObjHeight : CGFloat = 80
                        self.scrollView.subviews.forEach({$0.removeFromSuperview()})
                        for element : [String: AnyObject] in results{
                            let (latitude, longitude, addressShort, address) = Util.googleMapParse(element)
                            
                            if let customView = Bundle.main.loadNibNamed("MyLocationElementView", owner: self, options: nil)?.first as? MyLocationElementView {
                                customView.setLayout(self.ctrl, locationView: self, height: locObjHeight, idx: i, location: (latitude, longitude, addressShort, address))
                            }
                            i += 1
                        }
                        self.scrollView.contentSize.height = locObjHeight*i+30
                    }
                }
            })
        }else{
            Util.alert(self.ctrl, message: "검색어는 2글자 이상으로 넣어주세요.")
        }
    }
    
    
    
    func myLocationAction() {
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
            }, completion: { (_) in
                self.isHidden = true
                self.alpha = 1
                self.ctrl.blackScreen.isHidden = true
                if self.ctrl.isMyLocation == false{
                    Util.alert(self.ctrl, message: "설정-클러풀에 들어가셔서 위치 항상을 눌려주세요.")
                }else{
                    self.ctrl.locationManager.startUpdatingLocation()
                }
        })
    }
    
    
    
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        ctrl.view.endEditing(true)
        let tmpRect = self.frame
        //애니메이션 적용
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.y = -tmpRect.height
            }, completion: {(_) in
                self.ctrl.blackScreen.isHidden = true
                self.isHidden = true
                self.frame = tmpRect
        })
    }
    
    
    
    func centerViewShow(){
        self.ctrl.view.endEditing(true)
        self.scrollView.subviews.forEach({$0.removeFromSuperview()})
        self.scrollView.scrollToTop()
        self.ctrl.blackScreen.isHidden = false
        self.isHidden = false
        self.ctrl.courtSearchView.isHidden = true
        
        let tmpRect = self.frame
        self.frame.origin.y = -tmpRect.height
        //애니메이션 적용
        UIView.animate(withDuration: 0.3, animations: {
            self.self.frame = tmpRect
        }, completion: nil)
    }
}
