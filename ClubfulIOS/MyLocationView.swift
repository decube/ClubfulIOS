//
//  MainCenterView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MyLocationView : UIView{
    var locationArray = Array<Address>()
    @IBOutlet var tableView: UITableView!
    @IBOutlet var search: UITextField!
    @IBOutlet var myLocationView: UIView!
    var keyboardHideCallback: ((Void) -> Void)!
    var alertCallback: ((UIAlertController) -> Void)!
    var myLocationCallback: ((Void) -> Void)!
    
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
    
    func searchAction() {
        if (self.search.text?.characters.count)! >= 2{
            if self.keyboardHideCallback != nil{
                self.keyboardHideCallback()
            }
            
            self.locationArray = Array<Address>()
            self.tableView.reloadData()
            
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(self.search.text! as AnyObject, forKey: "address")
            parameters.updateValue(Util.language as AnyObject, forKey: "language")
            
            URLReq.request(url: URLReq.apiServer+"location/geocode", param: parameters, callback: { (dic) in
                if let results = dic["results"] as? [[String: AnyObject]]{
                    if results.count > 0{
                        for element : [String: AnyObject] in results{
                            self.locationArray.append(Util.googleMapParse(element))
                        }
                        self.tableView.reloadData()
                    }
                }
            })
        }else{
            if self.alertCallback != nil{
                self.alertCallback(Util.alert(message: "검색어는 2글자 이상으로 넣어주세요."))
            }
        }
    }
    
    
    func myLocationAction() {
        self.hideAlpha {
            let deviceUser = Storage.getRealmDeviceUser()
            deviceUser.deviceLatitude = Storage.latitude
            deviceUser.deviceLongitude = Storage.longitude
            deviceUser.isMyLocation = false
            Storage.setRealmDeviceUser(deviceUser)
            if self.myLocationCallback != nil{
                self.myLocationCallback()
            }
        }
    }
    
    
    func show(){
        if self.keyboardHideCallback != nil{
            self.keyboardHideCallback()
        }
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
        if self.keyboardHideCallback != nil{
            self.keyboardHideCallback()
        }
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
        if self.keyboardHideCallback != nil{
            self.keyboardHideCallback()
        }
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
