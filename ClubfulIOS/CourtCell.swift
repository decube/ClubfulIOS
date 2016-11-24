//
//  CourtCell.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 22..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtCell: UITableViewCell {
    
    @IBOutlet var imgView: UIView!
    @IBOutlet var courtName: UILabel!
    @IBOutlet var courtDesc: UILabel!
    @IBOutlet var star_1: UIImageView!
    @IBOutlet var star_2: UIImageView!
    @IBOutlet var star_3: UIImageView!
    @IBOutlet var star_4: UIImageView!
    @IBOutlet var star_5: UIImageView!
    @IBOutlet var location: UILabel!
    
    var callback: ((Void)->Void)!
    func setLayout(callback: @escaping ((Void)->Void)){
        self.callback = callback
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.courtAction)))
    }
    
    func courtAction(){
        if self.callback != nil{
            self.callback()
        }
    }
}
