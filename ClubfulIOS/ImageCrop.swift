//
//  ImageCrop.swift
//
//  Created by 맥북 on 2016. 5. 18..
//  Copyright © 2016년 맥북. All rights reserved.
//

import UIKit

public class ImageCrop {
    private var canvasView : UIView!
    private var canvasImageView : UIView!
    private var canvasImage : UIImageView!
    private var centerView : UIButton!
    
    private var leftTop : UIButton!
    private var rightTop : UIButton!
    private var leftBottom : UIButton!
    private var rightBottom : UIButton!
    private var top : CAShapeLayer!
    private var left : CAShapeLayer!
    private var right : CAShapeLayer!
    private var bottom : CAShapeLayer!
    
    private var isMapCrop : Bool!
    
    private var canvasColor : UIColor!
    private var cropDotSize : CGFloat!
    
    private var width : CGFloat!
    private var height : CGFloat!
    private var minRate : CGFloat!
    private var maxRate : CGFloat!
    private var widthValue : CGFloat!
    private var heightValue : CGFloat!
    
    
    private var pointX : CGFloat!
    private var pointY : CGFloat!
    
    public init(){}
    //크롭 설정
    public func setCrop(canvas : UIView!, image: UIImage!, width w : CGFloat, height h : CGFloat, initRate iR : CGFloat, minRate mnR : CGFloat, maxRate mxR : CGFloat, isMap : Bool = false, cropColor : UIColor, cropDotSize cds : CGFloat){
        
        //캔버스
        canvasView = canvas
        
        //변수 등록
        widthValue = w
        heightValue = h
        width = w*iR
        height = h*iR
        minRate = mnR
        maxRate = mxR
        canvasColor = cropColor
        cropDotSize = cds
        
        isMapCrop = isMap
        
        canvasImageView = UIView(frame: CGRect(x: 0, y: 0, width: self.canvasView.frame.width, height: self.canvasView.frame.height))
        self.canvasView.addSubview(canvasImageView)
        
        if isMapCrop == true{
            canvasImage = UIImageView(frame: CGRect(x: 0, y: 0, width: self.canvasImageView.frame.width, height: self.canvasImageView.frame.height))
        }else{
            let picWidth = image.size.width
            let picHeight = image.size.height
            if picWidth > picHeight{
                let canvasImageWidth = self.canvasImageView.frame.width
                let canvasImageHeight = canvasImageWidth * picHeight / picWidth
                canvasImage = UIImageView(frame: CGRect(x: 0, y: self.canvasImageView.frame.height/2-canvasImageHeight/2, width: canvasImageWidth, height: canvasImageHeight))
            }else{
                let canvasImageHeight = self.canvasImageView.frame.height
                let canvasImageWidth = canvasImageHeight * picWidth / picHeight
                canvasImage = UIImageView(frame: CGRect(x: self.canvasImageView.frame.width/2-canvasImageWidth/2, y: 0, width: canvasImageWidth, height: canvasImageHeight))
            }
        }
        
        self.canvasImageView.addSubview(canvasImage)
        canvasImage.image = image
        
        let black = UIView(frame: CGRect(x: 0, y: 0, width: self.canvasView.frame.width, height: self.canvasView.frame.height))
        black.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        self.canvasView.addSubview(black)
        
        self.centerView = UIButton(frame: CGRect(x: self.canvasView.frame.width/2-width/2, y: self.canvasView.frame.height/2-height/2, width: width, height: height))
        self.centerView.boxLayout(borderWidth: 2, borderColor: canvasColor)
        self.canvasView.addSubview(centerView)
        
        
        self.leftTop = self.setCropVertext(0, y: 0, rect: .TopLeft)
        self.rightTop = self.setCropVertext(self.centerView.frame.width, y: 0, rect: .TopRight)
        self.leftBottom = self.setCropVertext(0, y: self.centerView.frame.height, rect: .BottomLeft)
        self.rightBottom = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, rect: .BottomRight)
        self.top = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, edge: .Top)
        self.left = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, edge: .Left)
        self.right = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, edge: .Right)
        self.bottom = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, edge: .Bottom)
        
        //이벤트 등록
        self.centerView.addTarget(self, action: #selector(clickDown(_:event:)), forControlEvents: .TouchDown)
        self.leftTop.addTarget(self, action: #selector(clickDown(_:event:)), forControlEvents: .TouchDown)
        self.rightTop.addTarget(self, action: #selector(clickDown(_:event:)), forControlEvents: .TouchDown)
        self.leftBottom.addTarget(self, action: #selector(clickDown(_:event:)), forControlEvents: .TouchDown)
        self.rightBottom.addTarget(self, action: #selector(clickDown(_:event:)), forControlEvents: .TouchDown)
        
        
        self.centerView.addTarget(self, action: #selector(self.clickUp(_:event:)), forControlEvents: .TouchUpInside)
        self.leftTop.addTarget(self, action: #selector(self.clickUp(_:event:)), forControlEvents: .TouchUpInside)
        self.rightTop.addTarget(self, action: #selector(self.clickUp(_:event:)), forControlEvents: .TouchUpInside)
        self.leftBottom.addTarget(self, action: #selector(self.clickUp(_:event:)), forControlEvents: .TouchUpInside)
        self.rightBottom.addTarget(self, action: #selector(self.clickUp(_:event:)), forControlEvents: .TouchUpInside)
        
        self.centerView.addTarget(self, action: #selector(self.centerDrag(_:event:)), forControlEvents: .TouchDragInside)
        self.leftTop.addTarget(self, action: #selector(self.leftTopDrag(_:event:)), forControlEvents: .TouchDragInside)
        self.rightTop.addTarget(self, action: #selector(self.rightTopDrag(_:event:)), forControlEvents: .TouchDragInside)
        self.leftBottom.addTarget(self, action: #selector(self.leftBottomDrag(_:event:)), forControlEvents: .TouchDragInside)
        self.rightBottom.addTarget(self, action: #selector(self.rightBottomDrag(_:event:)), forControlEvents: .TouchDragInside)
        
        self.centerView.addTarget(self, action: #selector(self.centerViewClick(_:)), forControlEvents: .AllTouchEvents)
        
        cropImageSet(0)
    }
    @objc private func centerViewClick(sender: AnyObject){
        self.centerView.highlighted = false
    }
    private func cropImageSet(time : NSTimeInterval){
        var timer = NSTimer()
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(time, target: self, selector: #selector(self.copy(_:)), userInfo: nil, repeats: false)
    }
    @objc func copy(sender: AnyObject! = nil){
        let img = self.capture(true)
        self.centerView.setImage(img, forState: .Normal)
    }
    
    
    //캡쳐
    public func capture(imageResize : Bool = false) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(CGSize(width: self.centerView.frame.size.width, height: self.centerView.frame.size.height), false, 0.0)
        self.canvasImageView.drawViewHierarchyInRect(CGRect(x: -self.centerView.frame.origin.x, y: -self.centerView.frame.origin.y, width: self.canvasImageView.frame.size.width, height: self.canvasImageView.frame.size.height), afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if imageResize{
            return image
        }else{
            let imageValue = imageResizeFn(image, sizeChange: CGSize(width: widthValue, height: heightValue))
            return imageValue
        }
    }
    
    
    //회전
    public func rotate(){
        let image = self.canvasImage.image
        let imageValue = image?.imageRotatedByDegrees(90, flip: false)
        
        let picWidth = imageValue!.size.width
        let picHeight = imageValue!.size.height
        if picWidth > picHeight{
            let canvasImageWidth = self.canvasImageView.frame.width
            let canvasImageHeight = canvasImageWidth * picHeight / picWidth
            canvasImage.frame = CGRect(x: 0, y: self.canvasImageView.frame.height/2-canvasImageHeight/2, width: canvasImageWidth, height: canvasImageHeight)
        }else{
            let canvasImageHeight = self.canvasImageView.frame.height
            let canvasImageWidth = canvasImageHeight * picWidth / picHeight
            canvasImage.frame = CGRect(x: self.canvasImageView.frame.width/2-canvasImageWidth/2, y: 0, width: canvasImageWidth, height: canvasImageHeight)
        }
        
        self.canvasImage.image = imageValue
        self.centerView.frame = CGRect(x: self.canvasView.frame.width/2-self.centerView.frame.width/2, y: self.canvasView.frame.height/2-self.centerView.frame.height/2, width: self.centerView.frame.width, height: self.centerView.frame.height)
        canvasInit()
        cropImageSet(0.01)
    }
    
    //축소
    public func scale() -> Bool{
        let image = self.canvasImage.image
        let picWidth = image!.size.width
        let picHeight = image!.size.height
        let currentRect : CGRect
        
        var canvasImageWidth : CGFloat
        var canvasImageHeight : CGFloat
        
        if picWidth > picHeight{
            canvasImageWidth = self.canvasImageView.frame.width
            canvasImageHeight = canvasImageWidth * picHeight / picWidth
            currentRect = CGRect(x: 0, y: self.canvasImageView.frame.height/2-canvasImageHeight/2, width: canvasImageWidth, height: canvasImageHeight)
        }else{
            canvasImageHeight = self.canvasImageView.frame.height
            canvasImageWidth = canvasImageHeight * picWidth / picHeight
            currentRect = CGRect(x: self.canvasImageView.frame.width/2-canvasImageWidth/2, y: 0, width: canvasImageWidth, height: canvasImageHeight)
        }
        var returnValue = false
        if canvasImage.frame == currentRect{
            canvasImageWidth = canvasImageWidth*2/3
            canvasImageHeight = canvasImageHeight*2/3
            canvasImage.frame = CGRect(x: self.canvasImageView.frame.width/2-canvasImageWidth/2, y: self.canvasImageView.frame.height/2-canvasImageHeight/2, width: canvasImageWidth, height: canvasImageHeight)
            returnValue = true
        }else{
            if canvasImageWidth > canvasImageHeight{
                canvasImage.frame = CGRect(x: 0, y: self.canvasImageView.frame.height/2-canvasImageHeight/2, width: canvasImageWidth, height: canvasImageHeight)
            }else{
                canvasImage.frame = CGRect(x: self.canvasImageView.frame.width/2-canvasImageWidth/2, y: 0, width: canvasImageWidth, height: canvasImageHeight)
            }
        }
        
        self.centerView.frame = CGRect(x: self.centerView.frame.origin.x, y: self.centerView.frame.origin.y, width: self.centerView.frame.width, height: self.centerView.frame.height)
        cropImageSet(0.01)
        
        return returnValue
    }
    
    //이미지 리사이즈
    private func imageResizeFn(image:UIImage, sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    
    //절대값
    private func absolute(value : CGFloat) -> CGFloat{
        if value < 0{
            return value * -1
        }else{
            return value
        }
    }
    
    
    
    //캔버스 점을 초기화 시킴
    private func canvasInit(){
        cropImageSet(0)
        self.leftTop = self.setCropVertext(0, y: 0, btn: self.leftTop, rect: .TopLeft)
        self.rightTop = self.setCropVertext(self.centerView.frame.width, y: 0, btn: self.rightTop, rect: .TopRight)
        self.leftBottom = self.setCropVertext(0, y: self.centerView.frame.height, btn: self.leftBottom, rect: .BottomLeft)
        self.rightBottom = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, btn: self.rightBottom, rect: .BottomRight)
        self.top = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, btn: self.top, edge: .Top)
        self.left = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, btn: self.left, edge: .Left)
        self.right = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, btn: self.right, edge: .Right)
        self.bottom = self.setCropVertext(self.centerView.frame.width, y: self.centerView.frame.height, btn: self.bottom, edge: .Bottom)
    }
    
    //버튼 초기화
    private func setCropVertext(x : CGFloat, y : CGFloat, var btn : UIButton! = nil, rect : UIRectCorner = .AllCorners) -> UIButton{
        if btn == nil{
            btn = UIButton()
            btn.boxLayout(radius: CGFloat(M_PI * 2),borderWidth: 1, backgroundColor: canvasColor, borderColor:canvasColor)
            btn.clipsToBounds = true
            self.canvasView.addSubview(btn)
        }
        let cropDotSizeValue = cropDotSize
        if rect == .TopLeft{
            btn.frame = CGRect(x: x+self.centerView.frame.origin.x-cropDotSizeValue/4*2, y: y+self.centerView.frame.origin.y-cropDotSizeValue/4*2, width: cropDotSizeValue, height: cropDotSizeValue)
        }else if rect == .TopRight{
            btn.frame = CGRect(x: x+self.centerView.frame.origin.x-cropDotSizeValue/2, y: y+self.centerView.frame.origin.y-cropDotSizeValue/4*2, width: cropDotSizeValue, height: cropDotSizeValue)
        }else if rect == .BottomLeft{
            btn.frame = CGRect(x: x+self.centerView.frame.origin.x-cropDotSizeValue/4*2, y: y+self.centerView.frame.origin.y-cropDotSizeValue/2, width: cropDotSizeValue, height: cropDotSizeValue)
        }else if rect == .BottomRight{
            btn.frame = CGRect(x: x+self.centerView.frame.origin.x-cropDotSizeValue/2, y: y+self.centerView.frame.origin.y-cropDotSizeValue/2, width: cropDotSizeValue, height: cropDotSizeValue)
        }
        btn.layer.cornerRadius = btn.frame.size.width/2
        
        return btn
    }
    
    private func setCropVertext(x : CGFloat, y : CGFloat, var btn : CAShapeLayer! = nil, edge : UIRectEdge = .All) -> CAShapeLayer{
        if btn == nil{
            btn = CAShapeLayer().setView(self.canvasView)
        }
        if edge == .Top{
            let btnX = self.centerView.frame.origin.x+(self.centerView.frame.width)/2
            let btnY = self.centerView.frame.origin.y
            btn.layer(CGPoint(x: btnX , y: btnY), radius: cropDotSize/2, color: canvasColor)
        }else if edge == .Right{
            let btnX = self.centerView.frame.origin.x+(self.centerView.frame.width)
            let btnY = self.centerView.frame.origin.y+(self.centerView.frame.height)/2
            btn.layer(CGPoint(x: btnX , y: btnY), radius: cropDotSize/2, color: canvasColor)
        }else if edge == .Left{
            let btnX = self.centerView.frame.origin.x
            let btnY = self.centerView.frame.origin.y+(self.centerView.frame.height)/2
            btn.layer(CGPoint(x: btnX , y: btnY), radius: cropDotSize/2, color: canvasColor)
        }else if edge == .Bottom{
            let btnX = self.centerView.frame.origin.x+(self.centerView.frame.width)/2
            let btnY = self.centerView.frame.origin.y+(self.centerView.frame.height)
            btn.layer(CGPoint(x: btnX , y: btnY), radius: cropDotSize/2, color: canvasColor)
        }
        return btn
    }
    
    
    
    
    
    
    //사각형 밖에 나가면 초기화
    private func isOutside(point : CGPoint){
        var x = self.centerView.frame.origin.x
        var y = self.centerView.frame.origin.y
        if self.centerView.frame.origin.x <= 0{
            x = 0
        }
        if self.centerView.frame.origin.y <= 0{
            y = 0
        }
        if (self.centerView.frame.origin.x+self.centerView.frame.width) >= self.canvasView.frame.width{
            x = self.canvasView.frame.width-self.centerView.frame.width
        }
        if (self.centerView.frame.origin.y+self.centerView.frame.height) >= self.canvasView.frame.height{
            y = self.canvasView.frame.height-self.centerView.frame.height
        }
        
        self.centerView.frame = CGRect(x: x, y: y, width: self.centerView.frame.width, height: self.centerView.frame.height)
    }
    
    
    
    //사각형 밖에 못나가게 하기, 사각형 최소, 최대 사이즈
    private func quadrangleSize(width: CGFloat! = nil, height: CGFloat! = nil, corner : UIRectCorner, addWidth: CGFloat, addHeight: CGFloat) -> Bool{
        if self.centerView.frame.origin.x <= 0 && (corner == UIRectCorner.TopLeft || corner == UIRectCorner.BottomLeft){
            if addWidth < 0{
                return false
            }
        }
        if self.centerView.frame.origin.y <= 0 && (corner == UIRectCorner.TopLeft || corner == UIRectCorner.TopRight){
            if addHeight < 0{
                return false
            }
        }
        if self.centerView.frame.origin.x+self.centerView.frame.width >= self.canvasView.frame.width && (corner == UIRectCorner.TopRight || corner == UIRectCorner.BottomRight){
            if addWidth >= 0{
                return false
            }
        }
        if self.centerView.frame.origin.y+self.centerView.frame.height >= self.canvasView.frame.height && (corner == UIRectCorner.BottomRight || corner == UIRectCorner.BottomLeft){
            if addHeight >= 0{
                return false
            }
        }
        
        if width != nil && height != nil{
            if width >= (self.width*maxRate) || height >= (self.height*maxRate){
                self.centerView.frame = CGRect(x: self.centerView.frame.origin.x, y: self.centerView.frame.origin.y, width: self.width*maxRate, height: self.height*maxRate)
                canvasInit()
                return false
            }
            if width <= (self.width*minRate) || height <= (self.height*minRate){
                self.centerView.frame = CGRect(x: self.centerView.frame.origin.x, y: self.centerView.frame.origin.y, width: self.width*minRate, height: self.height*minRate)
                canvasInit()
                return false
            }
        }
        
        return true
    }
    
    
    
    
    
    
    
    //클릭, 클릭종료
    @objc private func clickDown(btn: UIButton!, event: UIEvent){
        if let touch = event.touchesForView(btn)?.first {
            let point : CGPoint = touch.previousLocationInView(self.canvasView)
            pointX = point.x
            pointY = point.y
        }
    }
    @objc private func clickUp(btn: UIButton!, event: UIEvent){
        if let touch = event.touchesForView(btn)?.first {
            let point : CGPoint = touch.previousLocationInView(self.canvasView)
            isOutside(point)
            pointX = nil
            pointY = nil
        }
    }
    
    
    
    //중앙 사각형 드래그
    @objc private func centerDrag(btn: UIButton!, event: UIEvent){
        if let touch = event.touchesForView(btn)?.first {
            let point : CGPoint = touch.previousLocationInView(self.canvasView)
            let addWidth = pointX - point.x
            let addHeight = pointY - point.y
            let originX = self.centerView.frame.origin.x
            let originY = self.centerView.frame.origin.y
            
            self.centerView.frame = CGRect(x: originX-addWidth, y: originY-addHeight, width: self.centerView.frame.width, height: self.centerView.frame.height)
            canvasInit()
            isOutside(point)
            pointX = point.x
            pointY = point.y
        }
    }
    
    
    
    //꼭지점 드래그
    
    
    @objc private func leftTopDrag(btn: UIButton!, event: UIEvent){
        if let touch = event.touchesForView(btn)?.first {
            let point : CGPoint = touch.previousLocationInView(self.canvasView)
            var addWidth = pointX - point.x
            var addHeight = pointY - point.y
            
            if absolute(addWidth) > absolute(addHeight){
                addWidth = addWidth * 1
                addHeight = addWidth*height/width
            }else{
                addHeight = addHeight * 1
                addWidth = addHeight*width/height
            }
            
            if quadrangleSize(self.centerView.frame.width+addWidth, height: self.centerView.frame.height+addHeight, corner: .TopLeft, addWidth: -addWidth, addHeight: -addHeight){
                self.centerView.frame = CGRect(x: self.centerView.frame.origin.x-addWidth, y: self.centerView.frame.origin.y-addHeight, width: self.centerView.frame.width+addWidth, height: self.centerView.frame.height+addHeight)
                canvasInit()
            }
            
            pointX = point.x
            pointY = point.y
        }
    }
    
    @objc private func rightTopDrag(btn: UIButton!, event: UIEvent){
        if let touch = event.touchesForView(btn)?.first {
            let point : CGPoint = touch.previousLocationInView(self.canvasView)
            var addWidth = pointX - point.x
            var addHeight = pointY - point.y
            
            if absolute(addWidth) > absolute(addHeight){
                addWidth = addWidth * -1
                addHeight = addWidth*height/width
            }else{
                addHeight = addHeight * 1
                addWidth = addHeight*width/height
            }
            
            if quadrangleSize(self.centerView.frame.width+addWidth, height: self.centerView.frame.height+addHeight, corner: .TopRight, addWidth: addWidth, addHeight: -addHeight){
                self.centerView.frame = CGRect(x: self.centerView.frame.origin.x, y: self.centerView.frame.origin.y-addHeight, width: self.centerView.frame.width+addWidth, height: self.centerView.frame.height+addHeight)
                canvasInit()
            }
            
            pointX = point.x
            pointY = point.y
        }
    }
    
    @objc private func leftBottomDrag(btn: UIButton!, event: UIEvent){
        if let touch = event.touchesForView(btn)?.first {
            let point : CGPoint = touch.previousLocationInView(self.canvasView)
            var addWidth = pointX - point.x
            var addHeight = pointY - point.y
            
            if absolute(addWidth) > absolute(addHeight){
                addWidth = addWidth * 1
                addHeight = addWidth*height/width
            }else{
                addHeight = addHeight * -1
                addWidth = addHeight*width/height
            }
            
            if quadrangleSize(self.centerView.frame.width+addWidth, height: self.centerView.frame.height+addHeight, corner: .BottomLeft, addWidth: -addWidth, addHeight: addHeight){
                self.centerView.frame = CGRect(x: self.centerView.frame.origin.x-addWidth, y: self.centerView.frame.origin.y, width: self.centerView.frame.width+addWidth, height: self.centerView.frame.height+addHeight)
                canvasInit()
            }
            
            pointX = point.x
            pointY = point.y
        }
    }
    
    @objc private func rightBottomDrag(btn: UIButton!, event: UIEvent){
        if let touch = event.touchesForView(btn)?.first {
            let point : CGPoint = touch.previousLocationInView(self.canvasView)
            var addWidth = pointX - point.x
            var addHeight = pointY - point.y
            
            if absolute(addWidth) > absolute(addHeight){
                addWidth = addWidth * -1
                addHeight = addWidth*height/width
            }else{
                addHeight = addHeight * -1
                addWidth = addHeight*width/height
            }
            
            if quadrangleSize(self.centerView.frame.width+addWidth, height: self.centerView.frame.height+addHeight, corner: .BottomRight, addWidth: addWidth, addHeight: addHeight){
                self.centerView.frame = CGRect(x: self.centerView.frame.origin.x, y: self.centerView.frame.origin.y, width: self.centerView.frame.width+addWidth, height: self.centerView.frame.height+addHeight)
                canvasInit()
            }
            
            pointX = point.x
            pointY = point.y
        }
    }
}