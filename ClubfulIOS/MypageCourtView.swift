//
//  MypageCourt.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 27..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MypageCourtView: UIView {
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    var court: Court!
    override func awakeFromNib() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(touchAction)))
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:))))
        self.isUserInteractionEnabled = true
    }
    
    var touchCallback: ((Court)->Void)!
    var pressedCallback: ((Court)->Void)!
    
    func setCourt(_ court: Court){
        self.court = court
        self.image.image = UIImage(data: court.imageData1)
        self.name.text = "\(court.cname!) (\(court.categoryName!) / \(court.address!))"
    }
    
    func touchAction(){
        if touchCallback != nil{
            touchCallback(court)
        }
    }
    
    func longPressed(_ sender: UILongPressGestureRecognizer){
        if sender.state == .began {
            if pressedCallback != nil{
                pressedCallback(court)
            }
        }
    }
}
