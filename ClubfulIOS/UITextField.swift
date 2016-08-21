//
//  UITextField.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
extension UITextField{
    func setLeftPadding(padding : CGFloat = 10){
        self.leftView = UIView(frame: CGRectMake(0, 0, padding, self.frame.height))
        self.leftViewMode = UITextFieldViewMode.Always
    }
    func setRightPadding(padding : CGFloat = 10){
        self.rightView = UIView(frame: CGRectMake(0, 0, padding, self.frame.height))
        self.rightViewMode = UITextFieldViewMode.Always
    }
    func maxLength(maxLength : Int){
        self.addControlEvent(.EditingChanged){
            if (self.text?.characters.count > maxLength) {
                self.deleteBackward()
            }
        }
    }
}
