//
//  MainCenterCellView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainCenterElementView : UIView{
    @IBOutlet var addressShort: UIButton!
    @IBOutlet var address: UIButton!
    
    func setAddr(addressShort addrShort : String, address addr : String){
        addressShort.setTitle(addrShort, forState: .Normal)
        address.setTitle(addr, forState: .Normal)
    }
    
    func setAction(action : ((Void) -> Void)){
        addressShort.addControlEvent(.TouchUpInside) {
            action()
        }
        address.addControlEvent(.TouchUpInside) {
            action()
        }
    }
}
