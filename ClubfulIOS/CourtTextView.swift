//
//  CourtTextView.swift
//  ClubfulIOS
//
//  Created by guanho on 2017. 1. 1..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

protocol CourtTextViewDelegate {
    func courtTextLoad()
    func courtTextReply(_ textField: UITextField)
}

class CourtTextView: UIView {
    var delegate: CourtTextViewDelegate?
    
    @IBOutlet var textField: UITextField!
    
    override func awakeFromNib() {
        
    }
    
    func load(){
        self.delegate?.courtTextLoad()
    }
    
    //리플 등록 클릭
    @IBAction func replyInsertAction(_ sender: AnyObject) {
        self.delegate?.courtTextReply(self.textField)
    }
}
