//
//  BallInfo.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 9. 11..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import AudioToolbox

class BallInfo{
    static let image = [
        UIImage(named: "ball_1.jpg"),
        UIImage(named: "ball_2.jpg"),
        UIImage(named: "ball_3.jpg"),
        UIImage(named: "ball_4.jpg"),
        UIImage(named: "ball_5.jpg"),
        UIImage(named: "ball_6.jpg"),
        UIImage(named: "ball_7.jpg"),
        UIImage(named: "ball_8.jpg")
    ]
    static var ballView: UIView!
    static var cols: Int!
    static var rows: Int!
    static var currentScoreLbl: UILabel!
    static var timeLbl: UILabel!
    static var ballArray : [Ball] =  []
    
    static var gameExit = false
    static var gamePause = false
    
    static var scoreHandeler : ((Int) -> Void)!
    
    static var ctrl: UIViewController!
    
    static func level(cols: Int, rows: Int){
        BallInfo.cols = cols
        BallInfo.rows = rows
        BallInfo.startBall()
        if self.currentScoreLbl != nil{
            scoreHandeler = {(score) in
                var currentScore = Int(BallInfo.currentScoreLbl.text!)!
                if currentScore < 0 || currentScore > 1000{
                    BallInfo.exit()
                    BallInfo.gameExit = true
                    if currentScore < 0{
                        Util.alert(BallInfo.ctrl, message: "아쉽네요...")
                    }else{
                        Util.alert(BallInfo.ctrl, message: "\(BallInfo.timeLbl.text!) 초 만에 클리어 하셨습니다. 기록을 전송하시겠습니까?", confirmTitle: "전송할께요.", cancelStr: "전송하지 않을래요.", confirmHandler: { (_) in
                            
                        })
                    }
                }else{
                    currentScore += score
                    BallInfo.currentScoreLbl.text = "\(currentScore)"
                }
            }
        }
        if timeLbl != nil{
            DispatchQueue.global().async {
                while BallInfo.gameExit == false{
                    if BallInfo.gamePause == false{
                        Thread.sleep(forTimeInterval: 0.1)
                        var timer = Double(BallInfo.timeLbl.text!)!
                        timer += 0.1
                        DispatchQueue.main.async {
                            BallInfo.timeLbl.text = "\(timer)"
                        }
                    }
                    Thread.sleep(forTimeInterval: 0.0001)
                }
            }
        }
    }
    
    static func start(_ ctrl: UIViewController, view: UIView, scoreLbl: UILabel! = nil, timeLbl: UILabel! = nil){
        BallInfo.ctrl = ctrl
        BallInfo.ballView = view
        BallInfo.currentScoreLbl = scoreLbl
        BallInfo.timeLbl = timeLbl
        let alert = UIAlertController(title:"",message:"난이도를 선택해 주세요.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:"상급",style: .default,handler:{ (alert) in self.level(cols: 3, rows: 4)}))
        alert.addAction(UIAlertAction(title:"중급",style: .default,handler:{ (alert) in self.level(cols: 3, rows: 3)}))
        alert.addAction(UIAlertAction(title:"하급",style: .default,handler:{ (alert) in self.level(cols: 2, rows: 3)}))
        alert.addAction(UIAlertAction(title:"사용자 지정",style: .default,handler:{ (alert) in
            let alert = UIAlertController(title:"",message:"어떻게 지정하시겠습니까?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title:"3X3",style: .default,handler:{ (alert) in self.level(cols: 3, rows: 3)}))
            alert.addAction(UIAlertAction(title:"3X4",style: .default,handler:{ (alert) in self.level(cols: 3, rows: 4)}))
            alert.addAction(UIAlertAction(title:"3X5",style: .default,handler:{ (alert) in self.level(cols: 3, rows: 5)}))
            alert.addAction(UIAlertAction(title:"4X3",style: .default,handler:{ (alert) in self.level(cols: 4, rows: 3)}))
            alert.addAction(UIAlertAction(title:"4X4",style: .default,handler:{ (alert) in self.level(cols: 4, rows: 4)}))
            alert.addAction(UIAlertAction(title:"4X5",style: .default,handler:{ (alert) in self.level(cols: 4, rows: 5)}))
            alert.addAction(UIAlertAction(title:"5X3",style: .default,handler:{ (alert) in self.level(cols: 5, rows: 3)}))
            alert.addAction(UIAlertAction(title:"5X4",style: .default,handler:{ (alert) in self.level(cols: 5, rows: 4)}))
            alert.addAction(UIAlertAction(title:"5X5",style: .default,handler:{ (alert) in self.level(cols: 5, rows: 5)}))
            ctrl.present(alert, animated: false, completion: {(_) in })
        }))
        ctrl.present(alert, animated: false, completion: {(_) in })
    }
    
    static func startBall(){
        let idxSize = BallInfo.cols*BallInfo.rows
        Ball.areaIdx = 0
        for _ in 0 ..< idxSize{
            let ball = Ball(isInit: true)
            BallInfo.ballArray.append(ball)
            BallInfo.gamePause = false
            BallInfo.gameExit = false
        }
    }
    static func gamePause(_ pause: Bool){
        BallInfo.gamePause = pause
        for ball in BallInfo.ballArray{
            ball.gamePause(pause)
        }
    }
    static func exit(){
        BallInfo.gameExit = true
        for ball in BallInfo.ballArray{
            ball.gameExit()
        }
    }
    static func delete(){
        BallInfo.gameExit = true
        for ball in BallInfo.ballArray{
            ball.gameRemove()
        }
    }
}

class Ball: UIImageView{
    var score = 20
    var isBoom = false
    var exit = false
    var pause = false
    
    var areaX: CGFloat!
    var areaY: CGFloat!
    var areaWidth: CGFloat!
    var areaHeight: CGFloat!
    
    var areaIdx: Int!
    static var areaIdx = 0
    
    
    convenience init(isInit: Bool) {
        self.init()
        let idxSize = BallInfo.cols*BallInfo.rows
        if idxSize-1 >= Ball.areaIdx{
            areaIdx = Ball.areaIdx
            Ball.areaIdx += 1
            
            let viewWidth = BallInfo.ballView.frame.width
            let viewHeight = BallInfo.ballView.frame.height
            
            let eachWidth = viewWidth/CGFloat(BallInfo.cols)
            let eachHeight = viewHeight/CGFloat(BallInfo.rows)
            
            self.areaWidth = eachWidth
            self.areaHeight = eachHeight
            
            for idxValue in 0 ..< idxSize{
                if areaIdx == idxValue{
                    areaX = eachWidth*CGFloat((idxValue%Int(BallInfo.cols)))
                    areaY = eachHeight*CGFloat((idxValue/Int(BallInfo.cols)))
                }
            }
            
            self.isUserInteractionEnabled = true
            self.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(self.pop)))
            self.changeImage()
            self.randomSize()
            BallInfo.ballView.addSubview(self)
            self.selfPop()
        }
    }
    
    func changeImage(){
        let imageRandom = arc4random_uniform(UInt32(BallInfo.image.count))
        self.image = BallInfo.image[Int(imageRandom)]
    }
    
    func gameRemove(){
        self.gameExit()
        self.removeFromSuperview()
    }
    
    func gameExit(){
        self.exit = true
        
    }
    func gamePause(_ pause: Bool){
        self.pause = pause
    }
    
    func pop(){
        if self.isBoom == false && self.isHidden == false && self.exit == false && self.pause == false{
            self.isBoom = true
            //self.boom()
            
            _ = Util.delay(0.3, task:{
                self.isHidden = true
            })
                
            if BallInfo.scoreHandeler != nil{
                BallInfo.scoreHandeler(self.score)
            }
            AudioServicesPlaySystemSound(4095)
            _ = Util.delay((Double(arc4random_uniform(27))+4)/10, task:{
                if self.isBoom == true && self.exit == false && self.pause == false{
                    self.isHidden = false
                    //self.reset()
                    self.changeImage()
                    self.randomSize()
                    self.selfPop()
                    self.isBoom = false
                }
            })
        }
    }
    
    func selfPop(){
        _ = Util.delay(Double(arc4random_uniform(60))/10+1, task:{
            if self.isBoom == false && self.isHidden == false && self.exit == false && self.pause == false{
                self.isBoom = true
                //애니메이션 적용
                UIView.animate(withDuration: 0.2, animations: {
                    self.alpha = 0
                }, completion: {(_) in
                    self.alpha = 1
                    self.isHidden = true
                })
                if BallInfo.scoreHandeler != nil{
                    BallInfo.scoreHandeler(-self.score)
                }
                _ = Util.delay((Double(arc4random_uniform(27))+4)/10, task:{
                    if self.isBoom == true && self.exit == false && self.pause == false{
                        self.isHidden = false
                        self.changeImage()
                        self.randomSize()
                        self.selfPop()
                        self.isBoom = false
                    }
                })
            }
        })
    }
    
    func randomSize(){
        var width = CGFloat(arc4random_uniform(UInt32(self.areaWidth/10*9))) + CGFloat(self.areaWidth/10)
        var height = CGFloat(arc4random_uniform(UInt32(self.areaHeight/10*9))) + CGFloat(self.areaHeight/10)
        if width > 90{
            width = 90
        }
        if height > 90{
            height = 90
        }
        score = 20
        if width > self.areaWidth/10*9{
            score -= 10
        }else if width > self.areaWidth/10*7{
            score -= 6
        }else if width > self.areaWidth/10*5{
            score -= 3
        }else if width > self.areaWidth/10*3{
            score += 0
        }else if width > self.areaWidth/10*1{
            score += 3
        }else{
            score += 6
        }
        if height > self.areaHeight/10*9{
            score -= 10
        }else if height > self.areaHeight/10*7{
            score -= 6
        }else if height > self.areaHeight/10*5{
            score -= 3
        }else if height > self.areaHeight/10*3{
            score += 0
        }else if height > self.areaHeight/10*1{
            score += 3
        }else{
            score += 6
        }
        
        var x = (self.areaX+(self.areaWidth)/2) - width/2
        var y = (self.areaY+(self.areaHeight)/2) - height/2
        let xRandom = arc4random_uniform(3)
        let yRandom = arc4random_uniform(3)
        if xRandom == 0{
            x = self.areaX
        }else if xRandom == 1{
            x = (self.areaX+self.areaWidth-width)
        }
        if yRandom == 0{
            y = self.areaY
        }else if yRandom == 1{
            y = (self.areaY+self.areaHeight-height)
        }
        if x < 10 && self.areaX == 0{
            x = 10
        }else if x > BallInfo.ballView.frame.width - 10{
            x = BallInfo.ballView.frame.width - 10
        }
        if y < 10 && self.areaY == 0{
            y = 10
        }else if y > BallInfo.ballView.frame.height - 10{
            y = BallInfo.ballView.frame.height - 10
        }
        
        self.frame = CGRect(x: x, y: y, width: width, height: height)
    }
}
