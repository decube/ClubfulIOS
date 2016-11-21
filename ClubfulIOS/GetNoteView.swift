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
    @IBOutlet var otherView: UIView!
    var msgLbl: UILabel!
    
    func setLayout(_ ctrl: MessageViewController, element: [String: AnyObject], isNew: Bool = false) -> CGFloat{
        self.ctrl = ctrl
        self.element = element
        
        self.msgLbl = UILabel()
        self.msgLbl.text = "\(self.element["message"]!)"
        let lines = self.getLines()
        self.msgLbl.numberOfLines = lines
        let heightValue: CGFloat = ceil((self.msgLbl.attributedText?.size().height)!*CGFloat(lines))
        if isNew{
            self.frame = CGRect(x: 0, y: self.ctrl.heightValue, width: self.ctrl.scrollView.frame.width, height: heightValue+20)
        }else{
            self.ctrl.scrollView.subviews.forEach({ (noteView) in
                noteView.frame.origin.y += heightValue+20
            })
            self.frame = CGRect(x: 0, y: 0, width: self.ctrl.scrollView.frame.width, height: heightValue+20)
        }
        self.ctrl.scrollView.addSubview(self)
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.1)
            DispatchQueue.main.async {
                let layer1 = CAShapeLayer()
                let layer2 = CAShapeLayer()
                let layer3 = CAShapeLayer()
                layer1.fillColor = UIColor(hex: 0xe5e5ea).cgColor
                layer2.fillColor = UIColor(hex: 0xe5e5ea).cgColor
                layer3.fillColor = UIColor(hex: 0xe5e5ea).cgColor
                layer1.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.messageView.frame.width, height: self.messageView.frame.height-10), byRoundingCorners: [UIRectCorner.allCorners], cornerRadii: CGSize(width: 10, height: 10)).cgPath
                layer2.path = UIBezierPath(roundedRect: CGRect(x: 10, y: 0, width: self.messageView.frame.width-10, height: self.messageView.frame.height), byRoundingCorners: [UIRectCorner.allCorners], cornerRadii: CGSize(width: 10, height: 10)).cgPath
                layer3.path = UIBezierPath(roundedRect: CGRect(x: 0, y: self.messageView.frame.height-20, width: 20, height: 20), byRoundingCorners: [UIRectCorner.bottomLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
                self.messageView.layer.addSublayer(layer1)
                self.messageView.layer.addSublayer(layer2)
                self.messageView.layer.addSublayer(layer3)
                
                self.msgLbl.frame = CGRect(x: 10, y: 5, width: self.messageView.frame.width-20, height: self.messageView.frame.height-10)
                self.messageView.addSubview(self.msgLbl)
            }
        }
        return heightValue+20
    }
    
    func getLines(lines: Int = 1) -> Int{
        if (self.ctrl.scrollView.frame.width/2-40)*CGFloat(lines) < (self.msgLbl.attributedText?.size().width)!{
            return self.getLines(lines: lines+1)
        }else{
            return lines
        }
    }
}
