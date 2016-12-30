//
//  MyCourtCell.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 12. 31..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MyCourtCell : UICollectionViewCell{
    @IBOutlet var img: UIImageView!
    @IBOutlet var txt: UILabel!
    @IBOutlet var spin: UIActivityIndicatorView!
    
    override func prepareForReuse() {
        self.img.image = nil
    }
}
