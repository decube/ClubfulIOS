//
//  MessageTextView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 19..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MessageTextView: UIView{
    var ctrl : MessageViewController!
    @IBOutlet var textField: UITextField!
    @IBOutlet var sendView: UIView!
    
    func setLayout(_ ctrl: MessageViewController){
        self.ctrl = ctrl
        self.textField.delegate = self.ctrl
        self.textField.borderStyle = .none
        self.sendView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sendAction)))
        self.frame = CGRect(x: 0, y: self.ctrl.msgView.frame.height-50, width: self.ctrl.view.frame.width, height: 50)
        self.ctrl.msgView.addSubview(self)
    }
    
    func sendAction(){
        if self.textField.text != ""{
            self.ctrl.sendAction()
        }
    }
}
