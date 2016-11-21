//
//  GetNoteView.swift
//  Expert
//
//  Created by guanho on 2016. 11. 18..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class GetNoteView: UIView {
    var ctrl: MessageViewController!
    var element: [String: AnyObject]!
    @IBOutlet var messageView: UIView!
    var msgLbl: UILabel!
    func setLayout(_ ctrl: MessageViewController, element: [String: AnyObject]) -> CGFloat{
        self.ctrl = ctrl
        self.element = element
        
        self.msgLbl = UILabel()
        self.msgLbl.text = "\(self.element["message"]!)"
        let lines = self.getLines()
        self.msgLbl.numberOfLines = lines
        
        let heightValue: CGFloat = (self.msgLbl.attributedText?.size().height)!*CGFloat(lines)
        self.ctrl.scrollView.subviews.forEach({ (noteView) in
            noteView.frame.origin.y += heightValue+30
        })
        self.frame = CGRect(x: 0, y: 0, width: self.ctrl.scrollView.frame.width/2, height: heightValue+30)
        self.ctrl.scrollView.addSubview(self)
        
        self.messageView.addSubview(self.msgLbl)
        self.msgLbl.frame = CGRect(x: 15, y: (self.frame.height-heightValue)/2, width: self.ctrl.msgViewWidth-20, height: heightValue)
        return heightValue+30
    }
    
    func getLines(lines: Int = 1) -> Int{
        if (self.ctrl.msgViewWidth-20)*CGFloat(lines) < (self.msgLbl.attributedText?.size().width)!{
            return self.getLines(lines: lines+1)
        }else{
            return lines
        }
    }
}
