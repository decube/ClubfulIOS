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
