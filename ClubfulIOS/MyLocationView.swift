//
//  MainCenterView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MyLocationView : UIView{
    var ctrl: ViewController!
    var locationArray = Array<Address>()
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var search: UITextField!
    @IBOutlet var myLocationView: UIView!
    
    override func awakeFromNib() {
        self.tableView.register(UINib(nibName: "MyLocationCell", bundle: nil), forCellReuseIdentifier: "MyLocationCell")
        self.myLocationView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.myLocationAction)))
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.separatorStyle = .none
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        hide()
    }
    @IBAction func blackScreenAction(_ sender: Any) {
        hide()
    }
    
    
    
    func setLayout(_ ctrl: ViewController){
        self.ctrl = ctrl
        self.frame = self.ctrl.view.frame
        self.search.delegate = ctrl
        self.ctrl.view.addSubview(self)
        self.tableView.delegate = ctrl
        self.tableView.dataSource = ctrl
    }
    
    
    func searchAction() {
        if (self.search.text?.characters.count)! >= 2{
            self.ctrl.view.endEditing(true)
            self.locationArray = Array<Address>()
            self.tableView.reloadData()
            
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(self.search.text! as AnyObject, forKey: "address")
            parameters.updateValue(Util.language as AnyObject, forKey: "language")
            
            URLReq.request(self.ctrl, url: URLReq.apiServer+"location/geocode", param: parameters, callback: { (dic) in
                if let results = dic["results"] as? [[String: AnyObject]]{
                    if results.count > 0{
                        for element : [String: AnyObject] in results{
                            let (latitude, longitude, addressShort, address) = Util.googleMapParse(element)
                            self.locationArray.append(Address(latitude: latitude, longitude: longitude, address: address, addressShort: addressShort))
                        }
                        self.tableView.reloadData()
                    }
                }
            })
        }else{
            Util.alert(self.ctrl, message: "검색어는 2글자 이상으로 넣어주세요.")
        }
    }
    
    
    func myLocationAction() {
        self.hideAlpha {
            let deviceUser = Storage.getRealmDeviceUser()
            deviceUser.deviceLatitude = Storage.latitude
            deviceUser.deviceLongitude = Storage.longitude
            deviceUser.isMyLocation = false
            Storage.setRealmDeviceUser(deviceUser)
            if self.ctrl.isMyLocation == false{
                Util.alert(self.ctrl, message: "설정-클러풀에 들어가셔서 위치 항상을 눌려주세요.")
            }else{
                self.ctrl.locationManager.startUpdatingLocation()
            }
        }
    }
    
    
    func show(){
        self.ctrl.view.endEditing(true)
        self.locationArray = Array<Address>()
        self.tableView.reloadData()
        self.isHidden = false
        let tmpRect = self.frame
        self.frame.origin.y = -tmpRect.height
        UIView.animate(withDuration: 0.3, animations: {
            self.frame = tmpRect
        }, completion: nil)
    }
    func hide(){
        self.ctrl.view.endEditing(true)
        self.locationArray = Array<Address>()
        self.tableView.reloadData()
        self.isHidden = false
        let tmpRect = self.frame
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.y = -tmpRect.height
        }, completion: {(_) in
            self.frame = tmpRect
            self.isHidden = true
        })
    }
    func hideAlpha(callback: @escaping (Void)->Void ){
        self.ctrl.view.endEditing(true)
        self.locationArray = Array<Address>()
        self.tableView.reloadData()
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: {(_) in
            self.isHidden = true
            self.alpha = 1
            callback()
        })
    }
}
