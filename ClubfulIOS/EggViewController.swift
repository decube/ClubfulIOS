//
//  EggViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 9. 10..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class EggViewController : UIViewController{
    @IBOutlet var timeLbl: UILabel!
    @IBOutlet var scoreLbl: UILabel!
    @IBOutlet var gameView: UIView!
    
    @IBOutlet var introBtn: UIButton!
    
    
    
    @IBAction func startAction(sender: UIButton) {
        sender.hidden = true
        BallInfo.start(self, view: self.gameView, scoreLbl: self.scoreLbl, timeLbl: self.timeLbl)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("EggViewController viewDidLoad")
    }
    
    
    @IBAction func introAction(sender: AnyObject) {
        if BallInfo.gameExit == false{
            if BallInfo.gamePause == false{
                BallInfo.gamePause(true)
                introBtn.setTitle("다시시작", forState: .Normal)
            }else{
                BallInfo.gamePause(false)
                introBtn.setTitle("일시중지", forState: .Normal)
            }
        }
    }
    
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        BallInfo.delete()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

