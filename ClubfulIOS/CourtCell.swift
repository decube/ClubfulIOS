//
//  CourtCell.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtCell: UITableViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var courtName: UILabel!
    @IBOutlet var courtDesc: UILabel!
    @IBOutlet var star_1: UIImageView!
    @IBOutlet var star_2: UIImageView!
    @IBOutlet var star_3: UIImageView!
    @IBOutlet var star_4: UIImageView!
    @IBOutlet var star_5: UIImageView!
    @IBOutlet var location: UILabel!
    
    
    override func awakeFromNib() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.courtAction)))
    }
    func setCourt(_ court: Court){
        self.courtName.text = court.cname
        self.courtDesc.text = court.description
        self.location.text = "\(getDistance(latitude: court.latitude, longitude: court.longitude)) K \(court.addressShort!)"
        DispatchQueue.global().async {
            if let imageUrl = Foundation.URL(string: court.image){
                if let imageData = try? Data(contentsOf: imageUrl){
                    if let image = UIImage(data: imageData){
                        DispatchQueue.main.async {
                            self.imgView.image = image
                        }
                    }
                }
            }
        }
    }
    
    var callback: ((Void)->Void)!
    func courtAction(){
        if self.callback != nil{
            self.callback()
        }
    }
    
    
    func getDistance(latitude : Double, longitude: Double) -> String{
        let currentLatitude = Storage.latitude
        let currentLongitude = Storage.longitude
        
        let currentRadiansX = (currentLatitude!*M_PI)/180
        let currentRadiansY = (currentLongitude!*M_PI)/180
        let radiansX = (latitude*M_PI)/180
        let radiansY = (longitude*M_PI)/180
        let distanceTmp = 6371*acos(cos(currentRadiansX)*cos(radiansX)*cos(radiansY-currentRadiansY)+sin(currentRadiansX)*sin(radiansX))
        let strArray = "\(distanceTmp)".components(separatedBy: ".")
        if strArray.count == 1{
            return strArray[0]
        }else{
            let firstStr = strArray[0]
            let sStr = strArray[1]
            let secondStr = sStr.substring(from: 0, to: 0)
            return firstStr+"."+String(secondStr)
        }
    }
    
    
    override func prepareForReuse() {
        self.imgView.image = UIImage()
    }
}
