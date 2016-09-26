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
        addressShort.setTitle(addrShort, for: UIControlState())
        address.setTitle(addr, for: UIControlState())
    }
    
    func setAction(_ action : @escaping ((Void) -> Void)){
        addressShort.addAction(.touchUpInside, action: {
            action()
        })
        address.addAction(.touchUpInside, action: {
            action()
        })
    }
}
