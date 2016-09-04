//
//  MainCenterView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class MainCenterView : UIView{
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var searchTextField: UITextField!
    
    
    var searchActionCallback : ((Void) -> Void)!
    var myLocationActionCallback : ((Void) -> Void)!
    
    @IBAction func searchAction(sender: AnyObject) {
        searchActionCallback()
    }
    @IBAction func myLocationAction(sender: AnyObject) {
        myLocationActionCallback()
    }
}
