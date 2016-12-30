//
//  MapListView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 6..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MapListView : UIView{
    @IBOutlet var tableView: UITableView!
    var keyboardHideCallback: ((Void) -> Void)!
    
    override func awakeFromNib() {
        self.tableView.register(UINib(nibName: "MapListCell", bundle: nil), forCellReuseIdentifier: "MapListCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.separatorStyle = .none
    }
    
    
    
    func show(){
        if self.keyboardHideCallback != nil{
            self.keyboardHideCallback()
        }
        let tmpRect = self.frame
        self.frame.origin.x = -tmpRect.width
        self.isHidden = false
        UIView.animate(withDuration: 0.2, animations: {
            self.frame = tmpRect
        })
    }
    
    func hide(){
        if self.keyboardHideCallback != nil{
            self.keyboardHideCallback()
        }
        let tmpRect = self.frame
        UIView.animate(withDuration: 0.2, animations: {
            self.frame.origin.x = -tmpRect.width
        }, completion: { (_) in
            self.isHidden = true
            self.frame = tmpRect
        })
    }
    
    func hideAlpha(_ callback: ((Void)->Void)! = nil){
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0
        }, completion: { (_) in
            self.isHidden = true
            self.alpha = 1
            if callback != nil{
                callback()
            }
        })
    }
    
    //코트서치 제스처
    @IBAction func handleGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended{
            let translation = sender.translation(in: self)
            let progress = MenuHelper.calculateProgress(translation, viewBounds: self.bounds, direction: .left)
            if progress > 0{
                if self.frame.origin.x < -Util.screenSize.width/4{
                    UIView.animate(withDuration: 0.2, animations: {
                        self.frame.origin.x = -self.frame.width
                    }, completion: {(_) in
                        self.isHidden = true
                        self.frame.origin.x = 0
                    })
                }else{
                    UIView.animate(withDuration: 0.2, animations: {
                        self.frame.origin.x = 0
                    }, completion: {(_) in
                        
                    })
                }
            }
        }else{
            let translation = sender.translation(in: self)
            let progress = MenuHelper.calculateProgress(translation, viewBounds: self.bounds, direction: .left)
            self.frame.origin.x = -(Util.screenSize.width/3*2)*progress
        }
    }
}
