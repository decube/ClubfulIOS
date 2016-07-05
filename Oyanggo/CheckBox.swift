//
//  CheckBox.swift
//  Flyerszone
//
//  Created by 맥북 on 2016. 5. 26..
//  Copyright © 2016년 맥북. All rights reserved.
//

import UIKit

class CheckBox: UIButton {
    // Images
    var checkedImage = UIImage(named: "ic_check_box.jpg")! as UIImage
    var uncheckedImage = UIImage(named: "ic_check_box_outline_blank.jpg")! as UIImage
    
    func setImage(checked : String, unchecked : String){
        checkedImage = UIImage(named: checked)!
        uncheckedImage = UIImage(named: unchecked)!
    }
    
    convenience init(){
        self.init()
        self.setTitle("", forState: .Normal)
        self.backgroundColor = UIColor.whiteColor()
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
    
    // Bool property
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImage, forState: .Normal)
            } else {
                self.setImage(uncheckedImage, forState: .Normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: #selector(self.buttonClicked(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
    
    func check(){
        self.setImage(checkedImage, forState: .Normal)
    }
    func uncheck(){
        self.setImage(uncheckedImage, forState: .Normal)
    }
}