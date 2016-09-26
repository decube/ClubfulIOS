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
    func setImage(_ imagePath: String, height: CGFloat, isCenter : Bool = false){
        DispatchQueue.global().async{
            if let imageURL = Foundation.URL(string: imagePath){
                if let imageData = try? Data(contentsOf: imageURL){
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
                    DispatchQueue.main.async {
                        self.image.frame = CGRect(x: x, y: (height-heightValue)/2, width: widthValue, height: heightValue)
                        self.image.image = courtImage
                    }
                }
            }
        }
    }
    func setLbl(title titleValue : String, desc descValue : String){
        title.text = titleValue
        desc.text = descValue
    }
    
    func setAction(_ action : @escaping (Void) -> Void){
        self.elementAction = action
        self.elementView.isUserInteractionEnabled = true
        self.elementView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.action(_:))))
    }
    func action(_ sender: AnyObject){
        self.elementAction()
    }
    func setSimplemapAction(_ action : @escaping ((Void) -> Void)){
        simplemap.addAction(.touchUpInside){
            action()
        }
    }
}
