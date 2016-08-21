//
//  MainCourtSearchElementView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainCourtSearchElementView: UIView{
    @IBOutlet var title: UIButton!
    @IBOutlet var desc: UIButton!
    @IBOutlet var simplemap: UIButton!
    
    
    func setLbl(title titleValue : String, desc descValue : String){
        title.setTitle(titleValue, forState: .Normal)
        desc.setTitle(descValue, forState: .Normal)
    }
    
    func setAction(action : ((Void) -> Void)){
        title.addControlEvent(.TouchUpInside) {
            action()
        }
        desc.addControlEvent(.TouchUpInside) {
            action()
        }
    }
    func setSimplemapAction(action : ((Void) -> Void)){
        simplemap.addControlEvent(.TouchUpInside) {
            action()
        }
    }
}
