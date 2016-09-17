//
//  UIView.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 8. 21..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit

extension UIView {
    func addDashedBorder(color : UIColor, lineWidth : CGFloat!, dashPattern : [NSNumber], cornerRadius : CGFloat) {
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.strokeColor = color.CGColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = dashPattern
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: cornerRadius).CGPath
        self.layer.addSublayer(shapeLayer)
    }
    func layer(rect: UIRectEdge = .Bottom, borderWidth : CGFloat = 1, color : UIColor = UIColor.blackColor(), border : CALayer = CALayer()) -> CALayer{
        UIRectEdge.Top
        border.borderColor = color.CGColor
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        if rect == UIRectEdge.Top{
            border.frame = CGRect(x: 0, y: 0, width:  self.frame.size.width, height: borderWidth)
        }else if rect == UIRectEdge.Bottom{
            border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width:  self.frame.size.width, height: borderWidth)
        }else if rect == UIRectEdge.Left{
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.frame.size.height)
        }else if rect == UIRectEdge.Right{
            border.frame = CGRect(x: self.frame.size.width - borderWidth, y: 0, width: borderWidth, height: self.frame.size.height)
        }
        return border
    }
}


@IBDesignable extension UIView {
    @IBInspectable var borderColor:UIColor? {
        set {
            layer.borderColor = newValue!.CGColor
        }
        get {
            if let color = layer.borderColor {
                return UIColor(CGColor:color)
            }
            else {
                return nil
            }
        }
    }
    @IBInspectable var borderWidth:CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    @IBInspectable var cornerRadius:CGFloat {
        set {
            layer.cornerRadius = newValue
            clipsToBounds = newValue > 0
        }
        get {
            return layer.cornerRadius
        }
    }
}