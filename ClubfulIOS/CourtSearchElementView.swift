//
//  MainCourtSearchElementView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtSearchElementView: UIView{
    var ctrl : ViewController!
    var courtSearchView: CourtSearchView!
    var element: [String: AnyObject]!
    @IBOutlet var elementView: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UITextView!
    @IBOutlet var image: UIImageView!
    
    
    
    func setLayout(_ ctrl: ViewController, courtSearchView: CourtSearchView, height: CGFloat, idx: CGFloat, element: [String: AnyObject]){
        self.ctrl = ctrl
        self.courtSearchView = courtSearchView
        self.element = element
        
        self.frame = CGRect(x: 0, y: height*idx, width: courtSearchView.scrollView.frame.width, height: height-1)
        self.elementView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.touchAction)))
        title.text = "\(element["cname"]!) (\(element["categoryName"]!) / \(element["addressShort"]!))"
        desc.text = "\(element["description"]!)"
        self.setImage(element["image"]! as! String, height: height-1)
        _ = self.layer()
        courtSearchView.scrollView.addSubview(self)
    }
    
    
    
    
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
    
    func touchAction(){
        self.ctrl.courtDetailSeq = element["seq"] as! Int
        self.ctrl.performSegue(withIdentifier: "main_courtDetail", sender: nil)
    }
    
    
    @IBAction func simplemapAction(_ sender: AnyObject) {
        let sname : String = "내위치".queryValue()
        let sx : Double = (ctrl.locationManager.location?.coordinate.latitude)!
        let sy : Double = (ctrl.locationManager.location?.coordinate.longitude)!
        let ename : String = "\(element["addressShort"]!)".queryValue()
        let ex : Double = element["latitude"] as! Double
        let ey : Double = element["longitude"] as! Double
        let simplemapUrl = "https://m.map.naver.com/route.nhn?menu=route&sname=\(sname)&sx=\(sx)&sy=\(sy)&ename=\(ename)&ex=\(ex)&ey=\(ey)&pathType=1&showMap=true"
        if let url = Foundation.URL(string: simplemapUrl){
            if UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:])
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
    }
}
