//
//  MainCourtSearchElementView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainCourtSearchElementView: UIView{
    @IBOutlet var title: UIButton!
    @IBOutlet var desc: UIButton!
    @IBOutlet var simplemap: UIButton!
    @IBOutlet var image: UIImageView!
    
    func setImage(imagePath: String, height: CGFloat){
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
                
                self.image.frame = CGRect(x: 0, y: (height-heightValue)/2, width: widthValue, height: heightValue)
                self.image.image = courtImage
            }
        }
    }
    func setLbl(title titleValue : String, desc descValue : String){
        title.setTitle(titleValue, forState: .Normal)
        desc.setTitle(descValue, forState: .Normal)
    }
    
    func setAction(action : ((Void) -> Void)){
        title.addControlEvent(.TouchUpInside) {
            action()
        }
        desc.addControlEvent(.TouchUpInside) {
            action()
        }
    }
    func setSimplemapAction(action : ((Void) -> Void)){
        simplemap.addControlEvent(.TouchUpInside) {
            action()
        }
    }
}
