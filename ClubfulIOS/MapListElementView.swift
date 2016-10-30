//
//  MainCenterCellView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MapListElementView : UIView{
    @IBOutlet var addressShort: UIButton!
    @IBOutlet var address: UIButton!
    
    var ctrl: MapViewController!
    var location: (Double, Double, String, String)!
    func setLayout(_ ctrl: MapViewController, height: CGFloat, idx: CGFloat, location: (Double, Double, String, String)){
        self.ctrl = ctrl
        self.location = location
        self.frame = CGRect(x: 5, y: height*idx+5, width: self.ctrl.mapListView.frame.width-10, height: height-10)
        addressShort.setTitle(location.2, for: UIControlState())
        address.setTitle(location.3, for: UIControlState())
        self.ctrl.mapListView.addSubview(self)
        
        if self.ctrl.mapListView.isHidden != false{
            let tmpRect = self.ctrl.mapListView.frame
            self.ctrl.mapListView.frame.origin.x = -tmpRect.width
            self.ctrl.mapListView.isHidden = false
            //애니메이션 적용
            UIView.animate(withDuration: 0.2, animations: {
                self.ctrl.mapListView.frame = tmpRect
                }, completion: {(_) in
            })
        }
    }
    
    @IBAction func addressAction1(_ sender: AnyObject) {
        setAction()
    }
    @IBAction func addressAction2(_ sender: AnyObject) {
        setAction()
    }
    func setAction(){
        UIView.animate(withDuration: 0.2, animations: {
            self.ctrl.mapListView.alpha = 0
            }, completion: { (_) in
                self.ctrl.mapListView.isHidden = true
                self.ctrl.mapListView.alpha = 1
                self.ctrl.locationMove(self.location.0, longitude: self.location.1)
        })
    }
}
