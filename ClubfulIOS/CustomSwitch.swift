//
//  CustomSwitch.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 12. 31..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation

extension UISwitch{
    func getYN() -> String{
        if self.isOn{
            return "Y"
        }else{
            return "N"
        }
    }
    func setYN(_ YN: String){
        if YN == "Y"{
            self.isOn = true
        }else{
            self.isOn = false
        }
    }
}
