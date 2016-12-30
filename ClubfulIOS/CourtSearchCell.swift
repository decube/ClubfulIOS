//
//  CourtSearchCell.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 26..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtSearchCell: UITableViewCell{
    var court: Court!
    
    @IBOutlet var elementView: UIView!
    @IBOutlet var title: UILabel!
    @IBOutlet var desc: UITextView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var simplemapView: UIView!
    
    override func awakeFromNib() {
        self.elementView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.touchAction)))
        self.simplemapView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.simplemapAction)))
        _ = self.layer()
    }
    
    func setCourt(_ court: Court){
        self.court = court
        self.title.text = "\(court.cname!) (\(court.categoryName!) / \(court.addressShort!))"
        self.desc.text = court.description
        
        if court.imageData1 == nil || court.imageData1.count == 0{
            DispatchQueue.global().async {
                if let imageUrl = Foundation.URL(string: court.image1){
                    if let imageData = try? Data(contentsOf: imageUrl){
                        court.imageData1 = imageData
                        if let image = UIImage(data: imageData){
                            DispatchQueue.main.async {
                                self.imgView.image = image
                            }
                        }else{
                            self.setNoImage()
                        }
                    }else{
                        self.setNoImage()
                    }
                }else{
                    self.setNoImage()
                }
            }
        }else{
            self.imgView.image = UIImage(data: court.imageData1)
        }
    }
    
    func setNoImage(){
        DispatchQueue.main.async {
            self.imgView.image = Util.noImage
        }
    }
    
    var touchCallback: ((Court) -> Void)!
    func touchAction(){
        if touchCallback != nil{
            touchCallback(self.court)
        }
    }
    var mapViewCallback: ((Court) -> Void)!
    
    
    func simplemapAction() {
        if mapViewCallback != nil{
            mapViewCallback(self.court)
        }
    }
    
    override func prepareForReuse() {
        self.imgView.image = UIImage()
    }
}
