//
//  CourtSearchView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 10. 30..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtSearchView : UIView{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var spin: UIActivityIndicatorView!
    
    var keyboardHideCallback: ((Void) -> Void)!
    
    override func awakeFromNib() {
        self.tableView.register(UINib(nibName: "CourtSearchCell", bundle: nil), forCellReuseIdentifier: "CourtSearchCell")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 90
        self.tableView.separatorStyle = .none
    }
    
    func show(){
        if self.keyboardHideCallback != nil{
            self.keyboardHideCallback()
        }
        if self.isHidden != false{
            self.frame.origin.x = -self.frame.width
            self.isHidden = false
            UIView.animate(withDuration: 0.2, animations: {
                self.frame.origin.x = 0
            }, completion: {(_) in
            })
        }else{
            self.frame.origin.x = 0
        }
    }
    func hide(){
        if self.keyboardHideCallback != nil{
            self.keyboardHideCallback()
        }
        self.tableView.reloadData()
        self.isHidden = false
        let tmpRect = self.frame
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin.x = -tmpRect.width
        }, completion: {(_) in
            self.isHidden = true
            self.frame = tmpRect
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
