//
//  MyLocationCell.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 26..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    @IBOutlet var addressShort: UILabel!
    @IBOutlet var address: UILabel!
    
    var addr: Address!
    
    override func awakeFromNib() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clickAction)))
    }
    
    func setAddress(_ addr: Address){
        self.addr = addr
        
        self.addressShort.text = addr.addressShort
        self.address.text = addr.address
    }
    
    
    var clickCallback: ((Address) -> Void)!
    
    func clickAction(){
        if clickCallback != nil{
            clickCallback(self.addr)
        }
    }
}
