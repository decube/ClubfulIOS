//
//  Util.swift
//  JundanJiZone
//
//  Created by guanho on 2016. 4. 6..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import UIKit

enum Ext{
    case JPEG, PNG
}

class Util{
    static let statusColor = UIColor(red:0.38, green:0.76, blue:0.91, alpha:1.00)
    static let commonColor = UIColor(red:0.38, green:0.76, blue:0.91, alpha:1.00)
    
    //언어
    static var language : String = (NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as? String)!
    //현재 버전
    static let nsVersion : String = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    //최신 버전
    static var newVersion : String!
    //디바이스id
    static let deviceId : String = UIDevice.currentDevice().identifierForVendor!.UUIDString
    //스크린 사이즈
    static let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    //다국어지원
    static func lang(key : String) -> String{
        return NSLocalizedString(key, comment: key)
    }
        
    
    //ajax 파람 데이터 파싱
    static func paramData(paramArrays : Array<NSDictionary>, encoding : String = "utf8") -> String{
        var returnString : String = ""
        let length = paramArrays.count
        for i in 0 ..< length {
            let param = paramArrays[i]
            var name = (param.valueForKey("name") as? String)!
            if i != 0 {name = "&"+name}
            
            if let value = param.valueForKey("value"){
                if(String(value) == ""){
                    returnString += (name+"=")
                }else{
                    if let classType = value.classForCoder{
                        if (classType == NSNumber.self){
                            returnString += (name+"="+String(value))
                        }else if (classType == NSString.self){
                            if encoding == "utf8"{
                                returnString += (name+"="+(value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet()))!)
                            }else{
                                
                            }
                        }else{
                            returnString += (name+"="+String(value))
                        }
                    }
                }
            }
        }
        return returnString
    }
    
    //stringify
    static func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        let options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : NSJSONWritingOptions(rawValue: 0)
        if NSJSONSerialization.isValidJSONObject(value) {
            do{
                let data = try NSJSONSerialization.dataWithJSONObject(value, options: options)
                if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
                    return string as String
                }
            }catch let error as NSError {
                print("JSON stringify error \(error)")
                //Access error here
            }
        }
        return ""
    }
    
    //parse
    static func parseJSON(dataStr: String) -> AnyObject{
        let data = (dataStr).dataUsingEncoding(NSUTF8StringEncoding)!
        var jsonResult :AnyObject
        do {
            jsonResult = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers)
            return jsonResult
        } catch let error as NSError {
            print("parseJSON error \(error)")
            jsonResult = ""
        }
        return jsonResult
    }
    
    
    
    //이미지 리사이즈
    static func imageResize (image:UIImage, sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    //확장자 구하기
    static func getExt(url : String, defaultExt : Ext = Ext.JPEG) -> Ext{
        if url.uppercaseString.rangeOfString("PNG") != nil{
            return Ext.PNG
        }else if url.uppercaseString.rangeOfString("JPEG") != nil || url.uppercaseString.rangeOfString("JPG") != nil{
            return Ext.JPEG
        }else {
            return defaultExt
        }
    }
    
    //이미지 데이터로 바꾸기
    static func returnImageData(image : UIImage!, ext : Ext) -> NSData{
        var data : NSData = NSData()
        switch ext {
        case .JPEG:
            if let tmpData = UIImageJPEGRepresentation(image, 0.5){
                data = tmpData
            }
            break
        case .PNG:
            if let tmpData = UIImagePNGRepresentation(image){
                data = tmpData
            }
            break
        }
        return data
    }
    
    
    //base64 문자열 인코딩
    static func base64Encoding(imageData : NSData) -> String{
        let base64String = imageData.base64EncodedStringWithOptions([])
        return base64String
    }
    
    //base64 문자열 디코딩
    static func base64Decoding(base64String : String) -> NSData{
        let imageData = NSData(base64EncodedString: base64String, options:NSDataBase64DecodingOptions(rawValue: 0))
        return imageData!
    }
    
    static func alert(title : String = Util.lang("common_alertTitle"), message : String, confirmTitle : String = Util.lang("common_alertConfirm"), ctrl : UIViewController, cancelStr :
        String = "" , confirmHandler : (UIAlertAction) -> Void = {(_) in}){
        var titleValue = title
        var confirmTitleValue = confirmTitle
        if titleValue == "common_alertTitle"{
            titleValue = "알람"
        }
        if confirmTitleValue == "common_alertConfirm"{
            confirmTitleValue = "확인"
        }
        
        let alert = UIAlertController(title:titleValue,message:message, preferredStyle: UIAlertControllerStyle.Alert)
        if cancelStr != ""{
            alert.addAction(UIAlertAction(title:cancelStr,style: .Cancel,handler:nil))
        }
        alert.addAction(UIAlertAction(title:confirmTitleValue,style: .Default,handler:confirmHandler))
        ctrl.presentViewController(alert, animated: false, completion: {(_) in })
    }
    
    
    
    static func convertStringToDictionary(data: NSData) -> [String:AnyObject] {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
        return Dictionary()
    }
}













extension String {
    //substring 추가
    public func substring(from:Int = 0, to:Int = -1) -> String {
        var toTmp = to
        if toTmp < 0 {
            toTmp = self.characters.count + toTmp
        }
        //from toTmp+1
        let range = self.startIndex.advancedBy(from)..<self.startIndex.advancedBy(toTmp+1)
        return self.substringWithRange(range)
    }
    public func substring(from:Int = 0, length:Int) -> String {
        let range = self.startIndex.advancedBy(from)..<self.startIndex.advancedBy(from+length)
        return self.substringWithRange(range)
    }
    
    public func range() -> Range<Index>{
        let range = self.startIndex.advancedBy(0)..<self.startIndex.advancedBy(self.characters.count-1)
        return range
    }
    public func queryValue() -> String{
        let value = self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        return value!
    }
}

extension UIView {
    convenience init(frame : CGRect, backgroundColor : UIColor) {
        self.init()
        self.frame = frame
        self.layer.backgroundColor = backgroundColor.CGColor
    }
    func boxLayout(corners: UIRectCorner? = nil, radius: CGFloat? = nil, borderWidth: CGFloat? = nil, backgroundColor : UIColor? = nil, borderColor : UIColor? = nil){
        if let radiusValue = radius{
            if let cornersValue = corners{
                let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: cornersValue, cornerRadii: CGSize(width: radiusValue, height: radius!))
                let mask = CAShapeLayer()
                mask.path = path.CGPath
                self.layer.mask = mask
            }else{
                self.layer.cornerRadius = radiusValue
            }
        }
        
        if let backColorValue = backgroundColor{
            self.layer.backgroundColor = backColorValue.CGColor
        }
        if let borderColorValue = borderColor{
            self.layer.borderColor = borderColorValue.CGColor
        }
        if let borderWidthValue = borderWidth{
            self.layer.borderWidth = borderWidthValue
        }
    }
    func boxBorder(rect: UIRectEdge, borderWidth : CGFloat = 1, color : UIColor = UIColor.blackColor(), border : CALayer = CALayer()) -> CALayer{
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
}




extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}






extension UITextField{
    convenience init(frame: CGRect, textColor: UIColor! = UIColor.blackColor(), placeholder: String, placeholderColor : UIColor! = nil, textAlignment : NSTextAlignment! = NSTextAlignment.Center, delegate : UITextFieldDelegate, fontSize: CGFloat = 0){
        self.init(frame: frame)
        self.textColor = textColor
        if placeholderColor == nil{
            self.placeholder = placeholder
        }else{
            self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName : placeholderColor])
        }
        self.textAlignment = textAlignment
        self.delegate = delegate
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.blackColor().CGColor
        if textAlignment == NSTextAlignment.Left{
            self.setLeftPadding()
        }
        if fontSize != 0{
            self.font = UIFont(name: (self.font?.fontName)!, size: fontSize)
        }
    }
    
    func setLeftPadding(padding : CGFloat = 10){
        self.leftView = UIView(frame: CGRectMake(0, 0, padding, self.frame.height))
        self.leftViewMode = UITextFieldViewMode.Always
    }
    func setRightPadding(padding : CGFloat = 10){
        self.rightView = UIView(frame: CGRectMake(0, 0, padding, self.frame.height))
        self.rightViewMode = UITextFieldViewMode.Always
    }
    func maxLength(maxLength : Int){
        self.addControlEvent(.EditingChanged){
            if (self.text?.characters.count > maxLength) {
                self.deleteBackward()
            }
        }
    }
    func maxLengthStr(maxLength : String){
        let maxLengthInt = Int(maxLength)
        self.addControlEvent(.EditingChanged){
            if (self.text?.characters.count > maxLengthInt) {
                self.deleteBackward()
            }
        }
    }
}



extension UIImageView{
    convenience init(frame: CGRect, named: String, view: UIView! = nil){
        self.init(frame: frame)
        self.image = UIImage(named: named)
        if view != nil{
            view.addSubview(self)
        }
    }
    convenience init(frame: CGRect, image: UIImage, view: UIView! = nil){
        self.init(frame: frame)
        self.image = image
        if view != nil{
            view.addSubview(self)
        }
    }
}

extension UIFont {
    static func printFontNames() {
        for familyName in UIFont.familyNames() {
            print("Family name: \(familyName)")
            for fontName in UIFont.fontNamesForFamilyName(familyName) {
                print("Font name: \(fontName)")
            }
        }
    }
}

extension UILabel{
    convenience init(frame: CGRect, text: String, color: UIColor = UIColor.blackColor(), textAlignment: NSTextAlignment = NSTextAlignment.Left, view: UIView! = nil, fontSize: CGFloat = 0){
        self.init(frame: frame)
        self.text = text
        self.textColor = color
        self.textAlignment = textAlignment
        if fontSize != 0{
            self.font = UIFont(name: (self.font?.fontName)!, size: fontSize)
        }
        if view != nil{
            view.addSubview(self)
        }
    }
}

extension UIButton{
    convenience init(frame: CGRect, dashPattern : [NSNumber]! = nil, view: UIView! = nil, text: String, color: UIColor = UIColor.blackColor(), fontSize : CGFloat = 0){
        self.init(frame: frame)
        if dashPattern != nil{
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
            self.addDashedBorder(UIColor.blackColor(), lineWidth: 2, dashPattern: dashPattern, cornerRadius: 0)
        }
        self.setTitle(text, forState: .Normal)
        self.setTitleColor(color, forState: .Normal)
        if view != nil{
            view.addSubview(self)
        }
        if fontSize != 0{
            let fontName : String = (self.titleLabel!.font?.fontName)!
            self.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: fontName, size: fontSize), size: fontSize)
        }
    }
    
    
    convenience init(frame: CGRect, image: UIImage, view: UIView! = nil, fontSize : CGFloat = 0){
        self.init(frame: frame)
        self.setImage(image, forState: .Normal)
        if view != nil{
            view.addSubview(self)
        }
        if fontSize != 0{
            let fontName : String = (self.titleLabel!.font?.fontName)!
            self.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: fontName, size: fontSize), size: fontSize)
        }
    }
    convenience init(frame: CGRect, named: String, view: UIView! = nil, fontSize : CGFloat = 0){
        self.init(frame: frame)
        self.setImage(UIImage(named: named), forState: .Normal)
        if view != nil{
            view.addSubview(self)
        }
        if fontSize != 0{
            let fontName : String = (self.titleLabel!.font?.fontName)!
            self.titleLabel!.font = UIFont(descriptor: UIFontDescriptor(name: fontName, size: fontSize), size: fontSize)
        }
    }
    
    func blackScreen() -> UIButton{
        self.frame = CGRect(x: 0, y: 20, width: Util.screenSize.width, height: Util.screenSize.height)
        self.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        self.hidden = true
        return self
    }
}
extension UIImage {
    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0)
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        //Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
extension CAShapeLayer{
    func layer(point : CGPoint, radius : CGFloat, color: UIColor){
        let circlePath = UIBezierPath(arcCenter: point, radius: radius, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        self.path = circlePath.CGPath
        self.fillColor = color.CGColor
        self.strokeColor = color.CGColor
        self.lineWidth = 1.0
    }
    func setView(view : UIView) -> CAShapeLayer{
        view.layer.addSublayer(self)
        return self
    }
}
extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
    }
    func scrollToBottom() {
        let desiredOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height)
        setContentOffset(desiredOffset, animated: true)
    }
}
extension NSDate{
    func yearInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Year, fromDate: self)
        let year = components.year
        return year
    }
    func monthInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Month, fromDate: self)
        let month = components.month
        return month
    }
    func dayInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Day, fromDate: self)
        let day = components.day
        return day
    }
    func hourInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Hour, fromDate: self)
        let hour = components.hour
        return hour
    }
    func minuteInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Minute, fromDate: self)
        let minute = components.minute
        return minute
    }
    func secondInt(calendar : NSCalendar) -> Int{
        let components = calendar.components(.Second, fromDate: self)
        let second = components.second
        return second
    }
    func year(calendar : NSCalendar) -> String{
        return "\(yearInt(calendar))"
    }
    func month(calendar : NSCalendar) -> String{
        let month = monthInt(calendar)
        if month < 10{
            return "0\(month)"
        }else{
            return "\(month)"
        }
    }
    func day(calendar : NSCalendar) -> String{
        let day = dayInt(calendar)
        if day < 10{
            return "0\(day)"
        }else{
            return "\(day)"
        }
    }
    func hour(calendar : NSCalendar) -> String{
        let hour = hourInt(calendar)
        if hour < 10{
            return "0\(hour)"
        }else{
            return "\(hour)"
        }
    }
    func minute(calendar : NSCalendar) -> String{
        let minute = minuteInt(calendar)
        if minute < 10{
            return "0\(minute)"
        }else{
            return "\(minute)"
        }
    }
    func second(calendar : NSCalendar) -> String{
        let second = secondInt(calendar)
        if second < 10{
            return "0\(second)"
        }else{
            return "\(second)"
        }
    }
    func getDate() -> String{
        let calendar = NSCalendar.currentCalendar()
        return "\(year(calendar))-\(month(calendar))-\(day(calendar))"
    }
    func getTime() -> String{
        let calendar = NSCalendar.currentCalendar()
        return "\(hour(calendar)):\(minute(calendar)):\(second(calendar))"
    }
    func getFullDate() -> String{
        return "\(getDate()) \(getTime())"
    }
}