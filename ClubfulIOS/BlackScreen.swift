//
//  BlackScreen.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 10. 30..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class BlackScreen: UIButton {
    var ctrl: UIViewController!
    convenience init(_ ctrl: UIViewController) {
        self.init()
        self.ctrl = ctrl
        
        self.frame = CGRect(x: 0, y: 0, width: ctrl.view.frame.width, height: ctrl.view.frame.height)
        self.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        self.isHidden = true
        ctrl.view.addSubview(self)
        
        //블랙스크린 클릭
        self.addAction(.touchUpInside) { (_) in
            if let vc = ctrl as? ViewController{
                vc.view.endEditing(true)
                if vc.myLocationView.isHidden == false{
                    let tmpRect = vc.myLocationView.frame
                    //애니메이션 적용
                    UIView.animate(withDuration: 0.2, animations: {
                        vc.myLocationView.frame.origin.y = -tmpRect.height
                        }, completion: {(_) in
                            self.isHidden = true
                            vc.myLocationView.isHidden = true
                            vc.myLocationView.frame = tmpRect
                    })
                }
            }
        }
    }
}
