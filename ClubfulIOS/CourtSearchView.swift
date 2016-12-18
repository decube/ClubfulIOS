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
    @IBOutlet var tableView: UITableView!
    @IBOutlet var spin: UIActivityIndicatorView!
    
    var courtArray: Array<Court> = Array<Court>()
    
    override func awakeFromNib() {
        self.tableView.register(UINib(nibName: "CourtSearchCell", bundle: nil), forCellReuseIdentifier: "CourtSearchCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 90
        self.tableView.separatorStyle = .none
    }
    
    
    func setLayout(_ ctrl: ViewController){
        self.ctrl = ctrl
        self.ctrl.view.addSubview(self)
        self.tableView.delegate = ctrl
        self.tableView.dataSource = ctrl
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.5)
            DispatchQueue.main.async {
                self.frame = CGRect(x: 0, y: 80, width: self.ctrl.view.frame.width/3*2, height: self.ctrl.view.frame.height-140)
                _ = self.layer(.right, borderWidth: 1, color: UIColor.black)
            }
        }
    }
    
    //코트 검색 액션
    func courtSearchAction() {
        if (self.ctrl.searchTextField.text?.characters.count)! >= 2{
            self.spin.isHidden = false
            self.spin.startAnimating()
            self.ctrl.view.endEditing(true)
            
            let deviceUser = Storage.getRealmDeviceUser()
            var latitude = deviceUser.latitude
            var longitude = deviceUser.longitude
            if deviceUser.isMyLocation == false{
                latitude = deviceUser.deviceLatitude
                longitude = deviceUser.deviceLongitude
            }
            
            var parameters : [String: AnyObject] = [:]
            parameters.updateValue(self.ctrl.searchTextField.text! as AnyObject, forKey: "search")
            parameters.updateValue(deviceUser.category as AnyObject, forKey: "category")
            parameters.updateValue(latitude as AnyObject, forKey: "latitude")
            parameters.updateValue(longitude as AnyObject, forKey: "longitude")
            URLReq.request(self.ctrl, url: URLReq.apiServer+"court/getList", param: parameters, callback: { (dic) in
                self.spin.isHidden = true
                self.spin.stopAnimating()
                if let list = dic["list"] as? [[String: AnyObject]]{
                    if list.count == 0{
                        Util.alert(self.ctrl, message: "해당 검색어에 코트가 없습니다.")
                    }else{
                        self.courtArray = []
                        for data in list{
                            self.courtArray.append(Court(data))
                        }
                        self.tableView.reloadData()
                        self.show()
                    }
                }
            })
        }else{
            Util.alert(self.ctrl, message: "검색어는 2글자 이상으로 넣어주세요.")
        }
    }
    
    
    func show(){
        self.ctrl.view.endEditing(true)
        if self.isHidden != false{
            self.frame.origin.x = -self.frame.width
            self.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.frame.origin.x = 0
            }, completion: {(_) in
            })
        }else{
            self.frame.origin.x = 0
        }
    }
    func hide(){
        self.ctrl.view.endEditing(true)
        self.courtArray = Array<Court>()
        self.tableView.reloadData()
        self.isHidden = false
        let tmpRect = self.frame
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = -tmpRect.width
        }, completion: {(_) in
            self.isHidden = true
            self.frame = tmpRect
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
