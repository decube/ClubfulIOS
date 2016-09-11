//
//  IntroViewController.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 9. 7..
//  Copyright © 2016년 guanho. All rights reserved.
//


import UIKit
import AudioToolbox

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
    var originWidth: CGFloat!
    var originHeight: CGFloat!
    
    
    var score1 = 10
    var score2 = 10
    var score3 = 10
    var score4 = 10
    var score5 = 10
    var score6 = 10
    var score7 = 10
    var score8 = 10
    
    var img1Origin : CGPoint!
    var img2Origin : CGPoint!
    var img3Origin : CGPoint!
    var img4Origin : CGPoint!
    var img5Origin : CGPoint!
    var img6Origin : CGPoint!
    var img7Origin : CGPoint!
    var img8Origin : CGPoint!
    
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
        
        self.originWidth = self.image1.frame.size.width
        self.originHeight = self.image1.frame.size.height
        
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
        img1Origin = image1.frame.origin
        img2Origin = image2.frame.origin
        img3Origin = image3.frame.origin
        img4Origin = image4.frame.origin
        img5Origin = image5.frame.origin
        img6Origin = image6.frame.origin
        img7Origin = image7.frame.origin
        img8Origin = image8.frame.origin
        
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
                NSThread.sleepForTimeInterval(0.0001)
            }
        })
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var boom : [UIImageView] = []
            while self.gameExit == false {
                if self.gamePause == false{
                    if self.mainScreenBoom{
                        var randomAdd = 0
                        if Int(self.score.currentTitle!) > 800{
                            randomAdd = 6
                        }else if Int(self.score.currentTitle!) > 600{
                            randomAdd = 5
                        }else if Int(self.score.currentTitle!) > 400{
                            randomAdd = 4
                        }else if Int(self.score.currentTitle!) > 200{
                            randomAdd = 3
                        }else if Int(self.score.currentTitle!) > 100{
                            randomAdd = 2
                        }
                        let numberRandom = Int(arc4random_uniform(3))+randomAdd
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
                                        boom.append(self.boomArray[start])
                                        self.boomArray[start].boom()
                                        self.boomArrayBoom[start] = true
                                        if Int(self.score.currentTitle!) > 800{
                                            self.scoreAdd(-33)
                                        }else if Int(self.score.currentTitle!) > 600{
                                            self.scoreAdd(-22)
                                        }else if Int(self.score.currentTitle!) > 400{
                                            self.scoreAdd(-15)
                                        }else if Int(self.score.currentTitle!) > 200{
                                            self.scoreAdd(-8)
                                        }else if Int(self.score.currentTitle!) > 100{
                                            self.scoreAdd(-3)
                                        }
                                    }
                                }
                            }
                        })
                    }else{
                        dispatch_async(dispatch_get_main_queue()) {
                            for image in boom{
                                self.randomSize(image)
                                if image == self.image1{
                                    self.boomArrayBoom[0] = false
                                }else if image == self.image2{
                                    self.boomArrayBoom[1] = false
                                }else if image == self.image3{
                                    self.boomArrayBoom[2] = false
                                }else if image == self.image4{
                                    self.boomArrayBoom[3] = false
                                }else if image == self.image5{
                                    self.boomArrayBoom[4] = false
                                }else if image == self.image6{
                                    self.boomArrayBoom[5] = false
                                }else if image == self.image7{
                                    self.boomArrayBoom[6] = false
                                }else if image == self.image8{
                                    self.boomArrayBoom[7] = false
                                }
                                image.reset()
                            }
                            boom = []
                        }
                    }
                    self.mainScreenBoom = !self.mainScreenBoom
                    sleep(2)
                }
            }
            NSThread.sleepForTimeInterval(0.0001)
        })
    }
    
    func randomSize(sender: UIImageView){
        let widthRandom = Int(arc4random_uniform(UInt32(self.originWidth/10*9))) + Int(self.originWidth/10)
        let heightRandom = Int(arc4random_uniform(UInt32(self.originHeight/10*9))) + Int(self.originHeight/10)
        var score = 20
        if widthRandom > 70{
            score -= 8
        }else if widthRandom > 60{
            score -= 6
        }else if widthRandom > 50{
            score -= 4
        }else if widthRandom > 40{
            score -= 2
        }else if widthRandom > 30{
            score += 0
        }else if widthRandom > 20{
            score += 3
        }else{
            score += 7
        }
        
        if heightRandom > 70{
            score -= 8
        }else if heightRandom > 60{
            score -= 6
        }else if heightRandom > 50{
            score -= 4
        }else if heightRandom > 40{
            score -= 2
        }else if heightRandom > 30{
            score += 0
        }else if heightRandom > 20{
            score += 3
        }else{
            score += 7
        }
        
        if sender == image1{
            score1 = score
            let x = (self.img1Origin.x+(self.originWidth)/2) - CGFloat(widthRandom/2)
            let y = (self.img1Origin.y+(self.originHeight)/2) - CGFloat(heightRandom/2)
            sender.frame = CGRect(x: x, y: y, width: CGFloat(widthRandom), height: CGFloat(heightRandom))
        }else if sender == image2{
            score2 = score
            let x = (self.img2Origin.x+(self.originWidth)/2) - CGFloat(widthRandom/2)
            let y = (self.img2Origin.y+(self.originHeight)/2) - CGFloat(heightRandom/2)
            sender.frame = CGRect(x: x, y: y, width: CGFloat(widthRandom), height: CGFloat(heightRandom))
        }else if sender == image3{
            score3 = score
            let x = (self.img3Origin.x+(self.originWidth)/2) - CGFloat(widthRandom/2)
            let y = (self.img3Origin.y+(self.originHeight)/2) - CGFloat(heightRandom/2)
            sender.frame = CGRect(x: x, y: y, width: CGFloat(widthRandom), height: CGFloat(heightRandom))
        }else if sender == image4{
            score4 = score
            let x = (self.img4Origin.x+(self.originWidth)/2) - CGFloat(widthRandom/2)
            let y = (self.img4Origin.y+(self.originHeight)/2) - CGFloat(heightRandom/2)
            sender.frame = CGRect(x: x, y: y, width: CGFloat(widthRandom), height: CGFloat(heightRandom))
        }else if sender == image5{
            score5 = score
            let x = (self.img5Origin.x+(self.originWidth)/2) - CGFloat(widthRandom/2)
            let y = (self.img5Origin.y+(self.originHeight)/2) - CGFloat(heightRandom/2)
            sender.frame = CGRect(x: x, y: y, width: CGFloat(widthRandom), height: CGFloat(heightRandom))
        }else if sender == image6{
            score6 = score
            let x = (self.img6Origin.x+(self.originWidth)/2) - CGFloat(widthRandom/2)
            let y = (self.img6Origin.y+(self.originHeight)/2) - CGFloat(heightRandom/2)
            sender.frame = CGRect(x: x, y: y, width: CGFloat(widthRandom), height: CGFloat(heightRandom))
        }else if sender == image7{
            score7 = score
            let x = (self.img7Origin.x+(self.originWidth)/2) - CGFloat(widthRandom/2)
            let y = (self.img7Origin.y+(self.originHeight)/2) - CGFloat(heightRandom/2)
            sender.frame = CGRect(x: x, y: y, width: CGFloat(widthRandom), height: CGFloat(heightRandom))
        }else if sender == image8{
            score8 = score
            let x = (self.img8Origin.x+(self.originWidth)/2) - CGFloat(widthRandom/2)
            let y = (self.img8Origin.y+(self.originHeight)/2) - CGFloat(heightRandom/2)
            sender.frame = CGRect(x: x, y: y, width: CGFloat(widthRandom), height: CGFloat(heightRandom))
        }
    }
    
    
    func image1Click(sender: UIImageView){
        if boomArrayBoom[0] == false && self.gamePause == false && self.gameExit == false{
            boomArrayBoom[0] = true
            image1.boom()
            AudioServicesPlaySystemSound(4095)
            self.delay(1, task:{
                self.image1.reset()
                self.randomSize(self.image1)
                self.boomArrayBoom[0] = false
            })
            scoreAdd(score1)
        }
    }
    func image2Click(sender: UIImageView){
        if boomArrayBoom[1] == false && self.gamePause == false && self.gameExit == false{
            boomArrayBoom[1] = true
            image2.boom()
            AudioServicesPlaySystemSound(4095)
            self.delay(1, task:{
                self.image2.reset()
                self.randomSize(self.image2)
                self.boomArrayBoom[1] = false
            })
            scoreAdd(score2)
        }
    }
    func image3Click(sender: UIImageView){
        if boomArrayBoom[2] == false && self.gamePause == false && self.gameExit == false{
            boomArrayBoom[2] = true
            image3.boom()
            AudioServicesPlaySystemSound(4095)
            self.delay(1, task:{
                self.image3.reset()
                self.randomSize(self.image3)
                self.boomArrayBoom[2] = false
            })
            scoreAdd(score3)
        }
    }
    func image4Click(sender: UIImageView){
        if boomArrayBoom[3] == false && self.gamePause == false && self.gameExit == false{
            boomArrayBoom[3] = true
            image4.boom()
            AudioServicesPlaySystemSound(4095)
            self.delay(1, task:{
                self.image4.reset()
                self.randomSize(self.image4)
                self.boomArrayBoom[3] = false
            })
            scoreAdd(score4)
        }
    }
    func image5Click(sender: UIImageView){
        if boomArrayBoom[4] == false && self.gamePause == false && self.gameExit == false{
            boomArrayBoom[4] = true
            image5.boom()
            AudioServicesPlaySystemSound(4095)
            self.delay(1, task:{
                self.image5.reset()
                self.randomSize(self.image5)
                self.boomArrayBoom[4] = false
            })
            scoreAdd(score5)
        }
    }
    func image6Click(sender: UIImageView){
        if boomArrayBoom[5] == false && self.gamePause == false && self.gameExit == false{
            boomArrayBoom[5] = true
            image6.boom()
            AudioServicesPlaySystemSound(4095)
            self.delay(1, task:{
                self.image6.reset()
                self.randomSize(self.image6)
                self.boomArrayBoom[5] = false
            })
            scoreAdd(score6)
        }
    }
    func image7Click(sender: UIImageView){
        if boomArrayBoom[6] == false && self.gamePause == false && self.gameExit == false{
            boomArrayBoom[6] = true
            image7.boom()
            AudioServicesPlaySystemSound(4095)
            self.delay(1, task:{
                self.image7.reset()
                self.randomSize(self.image7)
                self.boomArrayBoom[6] = false
            })
            scoreAdd(score7)
        }
    }
    func image8Click(sender: UIImageView){
        if boomArrayBoom[7] == false && self.gamePause == false && self.gameExit == false{
            boomArrayBoom[7] = true
            image8.boom()
            AudioServicesPlaySystemSound(4095)
            self.delay(1, task:{
                self.image8.reset()
                self.randomSize(self.image8)
                self.boomArrayBoom[7] = false
            })
            scoreAdd(score8)
        }
    }
    
    func scoreAdd(scoreNum: Int){
        if self.gameExit == false && self.gamePause == false{
            var scoreInt = Int(score.currentTitle!)!
            scoreInt += scoreNum
            
            if scoreInt <= 0 || scoreInt >= 1000{
                self.gameExit = true
                score.setTitle("\(scoreInt)", forState: .Normal)
                Util.alert(self, message: "총 \(Int(self.gameTimeLbl.text!)!) 초동안 노셨습니다.", confirmHandler: { (_) in
                    
                })
            }else{
                score.setTitle("\(scoreInt)", forState: .Normal)
            }
        }
    }
    
    @IBAction func scoreAction(sender: AnyObject) {
        self.gamePause = !self.gamePause
    }
    
    
    //뒤로가기
    @IBAction func backAction(sender: AnyObject) {
        self.gameExit = true
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}