//
//  CourtViewCell.swift
//  ClubfulIOS
//
//  Created by guanho on 2017. 1. 1..
//  Copyright © 2017년 guanho. All rights reserved.
//

import UIKit

protocol CourtViewCellDelgate {
    func courtViewDoubleTap()
    func courtViewLongGesture(_ imgTuple: (String, Data?))
}

class CourtViewCell: UICollectionViewCell {
    @IBOutlet var img: UIImageView!
    var imgTuple: (String, Data?)!
    
    var delegate: CourtViewCellDelgate?
    
    override func awakeFromNib() {
        //더블클릭
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(self.interestAction(_:)))
        doubleTap.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTap)
        //길게클릭
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(self.longPressed(_:))))
    }
    
    func interestAction(_ sender: AnyObject){
        self.delegate?.courtViewDoubleTap()
    }
    
    //길게 클릭
    func longPressed(_ sender: UILongPressGestureRecognizer){
        if sender.state == .ended {
        }else if sender.state == .began {
            self.delegate?.courtViewLongGesture(self.imgTuple)
        }
    }
}
