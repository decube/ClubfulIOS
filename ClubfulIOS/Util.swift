//
//  Util.swift
//  JundanJiZone
//
//  Created by guanho on 2016. 4. 6..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import UIKit


class Util{
    static let commonColor = UIColor(red:0.41, green:0.66, blue:0.12, alpha:1.00)
    
    //언어
    static var language : String = (NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as? String)!
    //현재 버전
    static let nsVersion : String = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
    //최신 버전
    static var newVersion : String! = "1.0.0"
    //디바이스id
    static let deviceId : String = UIDevice.currentDevice().identifierForVendor!.UUIDString
    //스크린 사이즈
    //static let screenSize: CGRect = UIScreen.mainScreen().bounds
    
    //다국어지원
    static func lang(key : String) -> String{
        return NSLocalizedString(key, comment: key)
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
    
    
    
    static func alert(ctrl : UIViewController, title : String = "알림", message : String, confirmTitle : String = "확인", cancelStr :
        String = "" , confirmHandler : (UIAlertAction) -> Void = {(_) in}, cancelHandler : (UIAlertAction) -> Void = {(_) in}){
        let alert = UIAlertController(title:title,message:message, preferredStyle: UIAlertControllerStyle.Alert)
        if cancelStr != ""{
            alert.addAction(UIAlertAction(title:cancelStr,style: .Cancel,handler:cancelHandler))
        }
        alert.addAction(UIAlertAction(title:confirmTitle,style: .Default,handler:confirmHandler))
        ctrl.presentViewController(alert, animated: false, completion: {(_) in })
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
    static func getExt(url : String, defaultExt : ExtType = ExtType.JPEG) -> ExtType{
        if url.uppercaseString.rangeOfString("PNG") != nil{
            return ExtType.PNG
        }else if url.uppercaseString.rangeOfString("JPEG") != nil || url.uppercaseString.rangeOfString("JPG") != nil{
            return ExtType.JPEG
        }else {
            return defaultExt
        }
    }
    
    //이미지 데이터로 바꾸기
    static func returnImageData(image : UIImage!, ext : ExtType) -> NSData{
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
    
    static func convertStringToDictionary(data: NSData) -> [String:AnyObject] {
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
        return Dictionary()
    }
    
    
    static func imageSaveHandler(ctrl: UIViewController, imageUrl: String, image: UIImage){
        let alert = UIAlertController(title:"알림",message:"저장하실 방법을 선택하세요.", preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title:"URL 복사",style: .Default,handler:{(_) in
            UIPasteboard.generalPasteboard().string = imageUrl
            Util.alert(ctrl, message: "복사되었습니다.")
        }))
        alert.addAction(UIAlertAction(title:"갤러리 저장",style: .Default,handler:{(_) in
            PhotoAlbumUtil.saveImageInAlbum(image, albumName: "clubful", completion: { (result) in
                switch result {
                case .SUCCESS:
                    dispatch_async(dispatch_get_main_queue(), {
                        Util.alert(ctrl, message: "저장되었습니다.")
                    })
                    break
                case .ERROR:
                    break
                case .DENIED:
                    break
                }
            })
        }))
        alert.addAction(UIAlertAction(title:"공유하기",style: .Default,handler:{(_) in
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            ctrl.presentViewController(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title:"인터넷으로 열기",style: .Default,handler:{(_) in
            if let url = NSURL(string: imageUrl){
                if UIApplication.sharedApplication().canOpenURL(url) {
                    UIApplication.sharedApplication().openURL(url)
                }
            }
        }))
        alert.addAction(UIAlertAction(title:"취소",style: .Cancel,handler:nil))
        ctrl.presentViewController(alert, animated: false, completion: {(_) in })
    }
    
    
    static func googleMapParse(element : [String: AnyObject]) -> (Double, Double, String, String){
        var latitude = 0.0
        var longitude = 0.0
        var addressShort = ""
        var address = ""
        if let locationGeometry = element["geometry"] as? [String:AnyObject]{
            if let location = locationGeometry["location"] as? [String:Double]{
                latitude = location["lat"]!
                longitude = location["lng"]!
            }
        }
        if let locationComponents = element["address_components"] as? [[String:AnyObject]]{
            for components : [String:AnyObject] in locationComponents{
                if let types = components["types"] as? [String]{
                    if types[0] == "sublocality_level_2"{
                        addressShort = components["long_name"] as! String
                        break
                    }
                }
            }
            if (addressShort == ""){
                for components : [String:AnyObject] in locationComponents{
                    if let types = components["types"] as? [String]{
                        if types[0] == "sublocality_level_1"{
                            addressShort = components["long_name"] as! String
                            break
                        }
                    }
                }
            }
            if (addressShort == ""){
                addressShort = locationComponents[0]["long_name"] as! String
            }
            address = element["formatted_address"] as! String
        }
        
        return (latitude, longitude, addressShort, address)
    }
    
    
    
    typealias Task = (cancel : Bool) -> ()
    static func delay(time:NSTimeInterval, task:()->()) ->  Task? {
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
        return result
    }
}