//
//  IntroViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 9. 7..
//  Copyright © 2016년 guanho. All rights reserved.
//

//
//  AppSetting.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

class IntroViewController : UIViewController{
    @IBOutlet var image1: UIImageView!
    @IBOutlet var image2: UIImageView!
    @IBOutlet var image3: UIImageView!
    @IBOutlet var image4: UIImageView!
    @IBOutlet var image5: UIImageView!
    @IBOutlet var image6: UIImageView!
    @IBOutlet var image7: UIImageView!
    @IBOutlet var image8: UIImageView!
    
    @IBOutlet var score: UIButton!
    
    var mainScreenBoom = true
    var boomArray : [UIImageView]!
    var boomArrayBoom : [Bool]!
    
    var image1Boom = false
    var image2Boom = false
    var image3Boom = false
    var image4Boom = false
    var image5Boom = false
    var image6Boom = false
    var image7Boom = false
    var image8Boom = false
    
    var gameExit = false
    var gamePause = false
    
    
    @IBOutlet var gameTimeLbl: UILabel!
    
    
    typealias Task = (cancel : Bool) -> ()
    func delay(time:NSTimeInterval, task:()->()) ->  Task? {
        func dispatch_later(block:()->()) {
            dispatch_after(
                dispatch_time(
                    DISPATCH_TIME_NOW,
                    Int64(time * Double(NSEC_PER_SEC))),
                dispatch_get_main_queue(),
                block)
        }
        var closure: dispatch_block_t? = task
        var result: Task?
        let delayedClosure: Task = {
            cancel in
            if let internalClosure = closure {
                if (cancel == false) {
                    dispatch_async(dispatch_get_main_queue(), internalClosure);
                }
            }
            closure = nil
            result = nil
        }
        result = delayedClosure
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(cancel: false)
            }
        }
        return result;
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("IntroViewController viewDidLoad")
        
        
        boomArray = [
            image1,
            image2,
            image3,
            image4,
            image5,
            image6,
            image7,
            image8
        ]
        boomArrayBoom = [
            image1Boom,
            image2Boom,
            image3Boom,
            image4Boom,
            image5Boom,
            image6Boom,
            image7Boom,
            image8Boom
        ]
        image1.userInteractionEnabled = true
        image2.userInteractionEnabled = true
        image3.userInteractionEnabled = true
        image4.userInteractionEnabled = true
        image5.userInteractionEnabled = true
        image6.userInteractionEnabled = true
        image7.userInteractionEnabled = true
        image8.userInteractionEnabled = true
        image1.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.image1Click(_:))))
        image2.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.image2Click(_:))))
        image3.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.image3Click(_:))))
        image4.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.image4Click(_:))))
        image5.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.image5Click(_:))))
        image6.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.image6Click(_:))))
        image7.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.image7Click(_:))))
        image8.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.image8Click(_:))))
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            while self.gameExit == false{
                if self.gamePause == false{
                    sleep(1)
                    var timer = Int(self.gameTimeLbl.text!)!
                    timer += 1
                    dispatch_async(dispatch_get_main_queue()) {
                        self.gameTimeLbl.text = "\(timer)"
                    }
                }
            }
        })
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            while self.gameExit == false {
                if self.gamePause == false{
                    if self.mainScreenBoom{
                        let numberRandom = Int(arc4random_uniform(3) + 3)
                        var indexArray = [Int]()
                        var idxAdd = 0
                        while(idxAdd != numberRandom){
                            let random = Int(arc4random_uniform(8))
                            var isAdd = true
                            for idx in indexArray{
                                if idx == random{
                                    isAdd = false
                                }
                            }
                            if isAdd == true{
                                indexArray.append(random)
                                idxAdd += 1
                            }
                        }
                        self.delay(0, task: {
                            dispatch_async(dispatch_get_main_queue()) {
                                for start in indexArray{
                                    if self.boomArrayBoom[start] == false{
                                        self.boomArray[start].boom()
                                        self.boomArrayBoom[start] = true
                                        self.scoreAdd(-10)
                                    }
                                }
                            }
                        })
                    }else{
                        dispatch_async(dispatch_get_main_queue()) {
                            for image in self.boomArray{
                                image.reset()
                            }
                            self.boomArrayBoom[0] = false
                            self.boomArrayBoom[1] = false
                            self.boomArrayBoom[2] = false
                            self.boomArrayBoom[3] = false
                            self.boomArrayBoom[4] = false
                            self.boomArrayBoom[5] = false
                            self.boomArrayBoom[6] = false
                            self.boomArrayBoom[7] = false
                        }
                    }
                    self.mainScreenBoom = !self.mainScreenBoom
                    sleep(2)
                }
            }
        })
    }
    
    func image1Click(sender: UIImageView){
        if boomArrayBoom[0] == false && self.gamePause == false && self.gameExit == false{
            image1.boom()
            self.delay(1, task:{
                self.image1.reset()
                self.boomArrayBoom[0] = false
            })
            boomArrayBoom[0] = true
            scoreAdd(10)
        }
    }
    func image2Click(sender: UIImageView){
        if boomArrayBoom[1] == false && self.gamePause == false && self.gameExit == false{
            image2.boom()
            self.delay(1, task:{
                self.image2.reset()
                self.boomArrayBoom[1] = false
            })
            boomArrayBoom[1] = true
            scoreAdd(10)
        }
    }
    func image3Click(sender: UIImageView){
        if boomArrayBoom[2] == false && self.gamePause == false && self.gameExit == false{
            image3.boom()
            self.delay(1, task:{
                self.image3.reset()
                self.boomArrayBoom[2] = false
            })
            boomArrayBoom[2] = true
            scoreAdd(10)
        }
    }
    func image4Click(sender: UIImageView){
        if boomArrayBoom[3] == false && self.gamePause == false && self.gameExit == false{
            image4.boom()
            self.delay(1, task:{
                self.image4.reset()
                self.boomArrayBoom[3] = false
            })
            boomArrayBoom[3] = true
            scoreAdd(10)
        }
    }
    func image5Click(sender: UIImageView){
        if boomArrayBoom[4] == false && self.gamePause == false && self.gameExit == false{
            image5.boom()
            self.delay(1, task:{
                self.image5.reset()
                self.boomArrayBoom[4] = false
            })
            boomArrayBoom[4] = true
            scoreAdd(10)
        }
    }
    func image6Click(sender: UIImageView){
        if boomArrayBoom[5] == false && self.gamePause == false && self.gameExit == false{
            image6.boom()
            self.delay(1, task:{
                self.image6.reset()
                self.boomArrayBoom[5] = false
            })
            boomArrayBoom[5] = true
            scoreAdd(10)
        }
    }
    func image7Click(sender: UIImageView){
        if boomArrayBoom[6] == false && self.gamePause == false && self.gameExit == false{
            image7.boom()
            self.delay(1, task:{
                self.image7.reset()
                self.boomArrayBoom[6] = false
            })
            boomArrayBoom[6] = true
            scoreAdd(10)
        }
    }
    func image8Click(sender: UIImageView){
        if boomArrayBoom[7] == false && self.gamePause == false && self.gameExit == false{
            image8.boom()
            self.delay(1, task:{
                self.image8.reset()
                self.boomArrayBoom[7] = false
            })
            boomArrayBoom[7] = true
            scoreAdd(10)
        }
    }
    
    func scoreAdd(scoreNum: Int){
        var scoreInt = Int(score.currentTitle!)!
        scoreInt += scoreNum
        
        if scoreInt <= 0 || scoreInt >= 1000{
            self.gameExit = true
            if scoreInt <= 0{
                score.setTitle("0", forState: .Normal)
            }else{
                score.setTitle("1000", forState: .Normal)
            }
            Util.alert(self, message: "총 \(Int(self.gameTimeLbl.text!)!) 초동안 노셨습니다.", confirmHandler: { (_) in
                
            })
        }else{
            score.setTitle("\(scoreInt)", forState: .Normal)
        }
    }
    
    @IBAction func scoreAction(sender: AnyObject) {
        self.gamePause = !self.gamePause
    }
    
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}