//
//  MapListView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 6..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MapListView : UIView{
    var ctrl : MapViewController!
    @IBOutlet var scrollView: UIScrollView!
    var spin: UIActivityIndicatorView!
    
    func setLayout(_ ctrl: MapViewController){
        self.ctrl = ctrl
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                self.frame = CGRect(x: 0, y: self.ctrl.mapView.frame.origin.y, width: self.ctrl.view.frame.width/3*2, height: self.ctrl.mapView.frame.height)
            }
        }
        
        self.backgroundColor = UIColor(red:0.86, green:0.90, blue:0.93, alpha:1.00)
        self.ctrl.view.addSubview(self)
    }
    
    func searchAction(){
        if (self.ctrl.searchField.text?.characters.count)! < 2{
            Util.alert(self.ctrl, message: "검색어를 2글자 이상 넣어주세요")
        }else{
            self.ctrl.view.endEditing(true)
            self.scrollView.subviews.forEach({$0.removeFromSuperview()})
            self.scrollView.scrollToTop()
            
            //지도 검색 통신
            let parameters : [String: AnyObject] = ["address": self.ctrl.searchField.text! as AnyObject, "language": Util.language as AnyObject]
            URLReq.request(self.ctrl, url: URLReq.apiServer+URLReq.api_location_geocode, param: parameters, callback: { (dic) in
                if let result = dic["results"] as? [String: AnyObject]{
                    if let results = result["results"] as? [[String: AnyObject]]{
                        //카운트가 1보다 많으면
                        if results.count > 1{
                            self.ctrl.view.endEditing(true)
                            self.scrollView.subviews.forEach({$0.removeFromSuperview()})
                            var i : CGFloat = 0
                            let locObjHeight : CGFloat = 80
                            
                            for element : [String: AnyObject] in results{
                                let (latitude, longitude, addressShort, address) = Util.googleMapParse(element)
                                
                                if let customView = Bundle.main.loadNibNamed("MapListElementView", owner: self, options: nil)?.first as? MapListElementView {
                                    customView.setLayout(self.ctrl, height: locObjHeight, idx: i, location: (latitude, longitude, addressShort, address))
                                }
                                i += 1
                            }
                            self.scrollView.contentSize.height = locObjHeight*i
                        }else{
                            //카운트가 1개 이면
                            for element : [String: AnyObject] in results{
                                var elementLatitude = 0.0
                                var elementLongitude = 0.0
                                if let locationGeometry = element["geometry"] as? [String:AnyObject]{
                                    if let location = locationGeometry["location"] as? [String:Double]{
                                        elementLatitude = location["lat"]!
                                        elementLongitude = location["lng"]!
                                    }
                                }
                                self.isHidden = true
                                self.ctrl.locationMove(latitude: elementLatitude, longitude: elementLongitude)
                            }
                        }
                    }
                }else{
                    if let isMsgView = dic["isMsgView"] as? Bool{
                        if isMsgView == true{
                            Util.alert(self.ctrl, message: "\(dic["msg"]!)")
                        }
                    }
                }
            })
        }
    }
    
    
    //코트서치 제스처
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended{
            let translation = sender.translation(in: self)
            let progress = MenuHelper.calculateProgress(translation, viewBounds: self.bounds, direction: .left)
            if progress > 0{
                if self.frame.origin.x < -self.ctrl.view.frame.width/4{
                    UIView.animate(withDuration: 0.2, animations: {
                        self.frame.origin.x = -self.frame.width
                    }, completion: {(_) in
                        self.isHidden = true
                        self.frame.origin.x = 0
                    })
                }else{
                    UIView.animate(withDuration: 0.2, animations: {
                        self.frame.origin.x = 0
                    }, completion: {(_) in
                        
                    })
                }
            }
        }else{
            let translation = sender.translation(in: self)
            let progress = MenuHelper.calculateProgress(translation, viewBounds: self.bounds, direction: .left)
            self.frame.origin.x = -(self.ctrl.view.frame.width/3*2)*progress
        }
    }
}
