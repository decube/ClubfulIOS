//
//  CourtElementView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 12..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtElementView: UIView{
    var ctrl : ViewController!
    var element: [String: AnyObject]!
    
    
    func setLayout(_ ctrl: ViewController, idx: CGFloat, element: [String: AnyObject]){
        self.ctrl = ctrl
        self.element = element
        
        self.frame = CGRect(x: 10, y: 160*idx+10, width: ctrl.scrollView.frame.width-20, height: 150)
        self.ctrl.scrollView.addSubview(self)
    }
}
