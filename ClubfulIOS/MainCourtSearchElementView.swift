//
//  MainCourtSearchElementView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainCourtSearchElementView: UIView{
    @IBOutlet var elementView: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UITextView!
    @IBOutlet var simplemap: UIButton!
    @IBOutlet var image: UIImageView!
    var elementAction : ((Void) -> Void)!
    func setImage(imagePath: String, height: CGFloat, isCenter : Bool = false){
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            if let imageURL = NSURL(string: imagePath){
                if let imageData = NSData(contentsOfURL: imageURL){
                    let courtImage = UIImage(data: imageData)
                    
                    var widthValue = self.image.frame.width
                    var heightValue = height
                    let imageWidth = courtImage!.size.width
                    let imageHeight = courtImage!.size.height
                    
                    let rateWidth = imageWidth/widthValue
                    let rateHeight = imageHeight/heightValue
                    
                    if rateWidth > rateHeight{
                        heightValue = widthValue * imageHeight / imageWidth
                    }else{
                        widthValue = heightValue * imageWidth / imageHeight
                    }
                    var x : CGFloat = 0
                    if isCenter == true{
                        x = (self.image.frame.width-widthValue)/2
                    }
                    dispatch_async(dispatch_get_main_queue()) {
                        self.image.frame = CGRect(x: x, y: (height-heightValue)/2, width: widthValue, height: heightValue)
                        self.image.image = courtImage
                    }
                }
            }
        })
    }
    func setLbl(title titleValue : String, desc descValue : String){
        title.text = titleValue
        desc.text = descValue
    }
    
    func setAction(action : ((Void) -> Void)){
        self.elementAction = action
        self.elementView.userInteractionEnabled = true
        self.elementView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.action)))
    }
    func action(){
        self.elementAction()
    }
    func setSimplemapAction(action : ((Void) -> Void)){
        simplemap.addAction(.TouchUpInside){
            action()
        }
    }
}
