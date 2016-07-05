//
//  LoginViewController.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class CourtMapViewController: UIViewController {
    var courtLatitude : CGFloat!
    var courtLongitude : CGFloat!
    override func viewDidLoad() {
        print("CourtMapViewController viewDidLoad")
        
        CustomView.initLayout(self, title: "약도")
    }
}


