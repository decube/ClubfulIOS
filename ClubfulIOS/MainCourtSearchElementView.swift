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
    
    
    func setLayout(_ ctrl: ViewController, height: CGFloat, idx: CGFloat, element: [String: AnyObject]){
        let titleStr = "\(element["cname"]!) (\(element["categoryName"]!) / \(element["addressShort"]!))"
        let descStr = "\(element["description"]!)"
        
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 0.1)
            DispatchQueue.main.async {
                self.frame = CGRect(x: 0, y: height*idx, width: ctrl.courtSearchScrollView.frame.size.width, height: height-1)
            }
        }
        
        
        
        self.setLbl(title: titleStr, desc: descStr)
        self.setImage(element["image"]! as! String, height: height-1)
        
        _ = self.layer()
        ctrl.courtSearchScrollView.addSubview(self)
        
        
        self.setAction({ (_) in
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let uvc = storyBoard.instantiateViewController(withIdentifier: "courtVC")
            (uvc as! CourtViewController).courtSeq = element["seq"] as! Int
            ctrl.navigationController?.pushViewController(uvc, animated: true)
        })
        self.backgroundColor = UIColor.orange
        self.setSimplemapAction({ (_) in
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
        })
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
