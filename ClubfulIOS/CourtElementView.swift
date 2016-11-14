//
//  CourtElementView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 12..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtElementView: UIView{
    var ctrl : ViewController!
    var element: [String: AnyObject]!
    @IBOutlet var imageView: UIView!
    
    func setLayout(_ ctrl: ViewController, idx: CGFloat, height: CGFloat, element: [String: AnyObject]){
        self.ctrl = ctrl
        self.element = element
        self.frame = CGRect(x: 10, y: ((height+10)*idx)+10, width: ctrl.scrollView.frame.width-20, height: height)
        self.ctrl.scrollView.addSubview(self)
        
        do{
            let image = UIImageView()
            self.imageView.addSubview(image)
            
            let rd = Int(arc4random_uniform(4))
            var urlStr = "http://post.phinf.naver.net/20160527_297/1464314639619UEOpr_JPEG/11.JPG?type=w1200"
            if rd == 0{
                urlStr = "http://post.phinf.naver.net/20160527_297/1464314639619UEOpr_JPEG/11.JPG?type=w1200"
            }else if rd == 1{
                urlStr = "http://imagescdn.gettyimagesbank.com/500/12/912/606/6/174800730.jpg"
            }else if rd == 2{
                urlStr = "http://postfiles5.naver.net/20120123_52/kenny790907_1327322190946s9Mjv_JPEG/IMG_5849.JPG?type=w1"
            }else if rd == 3{
                urlStr = "http://postfiles15.naver.net/20150209_190/imatrancer_1423415348869O6PNR_PNG/%B3%F3%B1%B8%C0%E5_%B3%F3%B1%B8%C4%DA%C6%AE_%284%29.png?type=w2"
            }else if rd == 4{
                urlStr = "http://imagescdn.gettyimagesbank.com/500/12/912/606/6/174800730.jpg"
            }
            
            let imageURL: URL = NSURL(string: urlStr) as! URL
            let courtImage = try UIImage(data: NSData(contentsOf: imageURL) as Data)
            let courtImageSize = courtImage?.size
            DispatchQueue.global().async {
                Thread.sleep(forTimeInterval: 0.1)
                DispatchQueue.main.async {
                    let imageWidth = self.imageView.frame.width
                    let imageHeight = imageWidth*(courtImageSize?.height)!/(courtImageSize?.width)!
                    
                    
                    image.frame = CGRect(x: 0, y: 0, width: imageWidth, height: imageHeight)
                    if self.imageView.frame.height >= imageHeight{
                        image.image = courtImage
                    }else{
                        image.image = courtImage?.crop(to: CGSize(width: imageWidth, height: imageHeight))
                    }
                }
            }
        }catch{
            
        }
    }
}
