//
//  MapListCell.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 27..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MapListCell : UITableViewCell{
    @IBOutlet var addressShort: UILabel!
    @IBOutlet var address: UILabel!
    var addr: Address!
    
    override func awakeFromNib() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchAction)))
    }
    
    func setAddress(_ addr: Address){
        self.addr = addr
        self.addressShort.text = addr.addressShort
        self.address.text = addr.address
    }
    
    var touchCallback: ((Address) -> Void)!
    func touchAction(){
        if touchCallback != nil{
            touchCallback(self.addr)
        }
    }
}
