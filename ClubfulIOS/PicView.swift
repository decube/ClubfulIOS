//
//  PicView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 26..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class PicView: UIView {
    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchAction)))
    }
    
    var touchCallback: ((Void) -> Void)!
    func touchAction(){
        if touchCallback != nil{
            touchCallback()
        }
    }
}
