//
//  SendNoteView.swift
//  Expert
//
//  Created by guanho on 2016. 11. 18..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class SendNoteView: UIView {
    var ctrl: MessageViewController!
    var element: [String: AnyObject]!
    
    func setLayout(_ ctrl: MessageViewController, element: [String: AnyObject]) -> CGFloat{
        self.ctrl = ctrl
        self.element = element
        
        let heightValue: CGFloat = 70
        
        self.frame = CGRect(x: self.ctrl.scrollView.frame.width/2, y: 0, width: self.ctrl.scrollView.frame.width/2, height: heightValue)
        
        self.ctrl.scrollView.subviews.forEach({ (noteView) in
            noteView.frame.origin.y += heightValue
        })
        self.ctrl.scrollView.addSubview(self)
        
        return heightValue
    }
}
