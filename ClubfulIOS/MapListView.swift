//
//  MapListView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 6..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MapListView : UIView{
    @IBOutlet var tableView: UITableView!
    var ctrl : MapViewController!
    
    var addressArray = Array<Address>()
    
    override func awakeFromNib() {
        self.tableView.register(UINib(nibName: "MapListCell", bundle: nil), forCellReuseIdentifier: "MapListCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.separatorStyle = .none
    }
    
    func setLayout(_ ctrl: MapViewController){
        self.ctrl = ctrl
        self.tableView.dataSource = ctrl
        self.tableView.delegate = ctrl
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                self.frame = CGRect(x: 0, y: self.ctrl.mapView.frame.origin.y, width: self.ctrl.view.frame.width/3*2, height: self.ctrl.mapView.frame.height)
            }
        }
        self.ctrl.view.addSubview(self)
    }
    
    func searchAction(){
        if (self.ctrl.searchField.text?.characters.count)! < 2{
            Util.alert(self.ctrl, message: "검색어를 2글자 이상 넣어주세요")
        }else{
            self.ctrl.view.endEditing(true)
            self.addressArray = Array<Address>()
            self.tableView.reloadData()
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(self.ctrl.searchField.text! as AnyObject, forKey: "address")
            parameters.updateValue(Util.language as AnyObject, forKey: "language")
            URLReq.request(self.ctrl, url: URLReq.apiServer+URLReq.api_location_geocode, param: parameters, callback: { (dic) in
                if let result = dic["results"] as? [String: AnyObject]{
                    if let results = result["results"] as? [[String: AnyObject]]{
                        if results.count > 1{
                            //카운트가 1보다 많으면
                            self.ctrl.view.endEditing(true)
                            for element : [String: AnyObject] in results{
                                let (latitude, longitude, addressShort, address) = Util.googleMapParse(element)
                                self.addressArray.append(Address(latitude: latitude, longitude: longitude, address: address, addressShort: addressShort))
                            }
                            self.tableView.reloadData()
                            self.show()
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
    
    func show(){
        self.ctrl.view.endEditing(true)
        let tmpRect = self.frame
        self.frame.origin.x = -tmpRect.width
        self.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = tmpRect
        })
    }
    
    func hide(){
        self.ctrl.view.endEditing(true)
        let tmpRect = self.frame
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.x = -tmpRect.width
        }, completion: { (_) in
            self.isHidden = true
            self.frame = tmpRect
        })
    }
    
    func hideAlpha(_ callback: ((Void)->Void)! = nil){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { (_) in
            self.isHidden = true
            self.alpha = 1
            if callback != nil{
                callback()
            }
        })
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
