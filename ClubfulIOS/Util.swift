//
//  Util.swift
//  JundanJiZone
//
//  Created by guanho on 2016. 4. 6..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import UIKit

enum ExtType{
    case jpeg, png
}
class Util{
    static let commonColor = UIColor(red:0.41, green:0.66, blue:0.12, alpha:1.00)
    
    //언어
    static var language : String = ((Locale.current as NSLocale).object(forKey: NSLocale.Key.languageCode) as? String)!
    //현재 버전
    static let nsVersion : String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    //최신 버전
    static var newVersion : String! = "1.0.0"
    //디바이스id
    static let deviceId : String = UIDevice.current.identifierForVendor!.uuidString
    //스크린 사이즈
    static let screenSize: CGRect = UIScreen.main.bounds
    
    //다국어지원
    static func lang(_ key : String) -> String{
        return NSLocalizedString(key, comment: key)
    }
    
    //stringify
    static func JSONStringify(_ value: AnyObject,prettyPrinted:Bool = false) -> String{
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
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
    static func parseJSON(_ dataStr: String) -> AnyObject{
        let data = (dataStr).data(using: String.Encoding.utf8)!
        var jsonResult :Any
        do {
            jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers)
            return jsonResult as AnyObject
        } catch let error as NSError {
            print("parseJSON error \(error)")
            jsonResult = "" as AnyObject
        }
        return jsonResult as AnyObject
    }
    
    
    
    static func alert(_ ctrl : UIViewController, title : String = "알림", message : String, confirmTitle : String = "확인", cancelStr :
        String = "" , confirmHandler : @escaping (UIAlertAction) -> Void = {(_) in}, cancelHandler : @escaping (UIAlertAction) -> Void = {(_) in}){
        let alert = UIAlertController(title:title,message:message, preferredStyle: UIAlertControllerStyle.alert)
        if cancelStr != ""{
            alert.addAction(UIAlertAction(title:cancelStr,style: .cancel,handler:cancelHandler))
        }
        alert.addAction(UIAlertAction(title:confirmTitle,style: .default,handler:confirmHandler))
        ctrl.present(alert, animated: false, completion: {(_) in })
    }
    
    
    //이미지 리사이즈
    static func imageResize (_ image:UIImage, sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        image.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
    
    //확장자 구하기
    static func getExt(_ url : String, defaultExt : ExtType = ExtType.jpeg) -> ExtType{
        if url.uppercased().range(of: "PNG") != nil{
            return ExtType.png
        }else if url.uppercased().range(of: "JPEG") != nil || url.uppercased().range(of: "JPG") != nil{
            return ExtType.jpeg
        }else {
            return defaultExt
        }
    }
    
    //이미지 데이터로 바꾸기
    static func returnImageData(_ image : UIImage!, ext : ExtType) -> Data{
        var data : Data = Data()
        switch ext {
        case .jpeg:
            if let tmpData = UIImageJPEGRepresentation(image, 0.5){
                data = tmpData
            }
            break
        case .png:
            if let tmpData = UIImagePNGRepresentation(image){
                data = tmpData
            }
            break
        }
        return data
    }
    
    
    //base64 문자열 인코딩
    static func base64Encoding(_ imageData : Data) -> String{
        let base64String = imageData.base64EncodedString(options: [])
        return base64String
    }
    
    //base64 문자열 디코딩
    static func base64Decoding(_ base64String : String) -> Data{
        let imageData = Data(base64Encoded: base64String, options:NSData.Base64DecodingOptions(rawValue: 0))
        return imageData!
    }
    
    static func convertStringToDictionary(_ data: Data) -> [String:AnyObject] {
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
        } catch let error as NSError {
            print(error)
        }
        return Dictionary()
    }
    
    
    static func imageSaveHandler(_ ctrl: UIViewController, imageUrl: String, image: UIImage){
        let alert = UIAlertController(title:"알림",message:"저장하실 방법을 선택하세요.", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:"URL 복사",style: .default,handler:{(_) in
            UIPasteboard.general.string = imageUrl
            Util.alert(ctrl, message: "복사되었습니다.")
        }))
        alert.addAction(UIAlertAction(title:"갤러리 저장",style: .default,handler:{(_) in
            PhotoAlbumUtil.saveImageInAlbum(image, albumName: "clubful", completion: { (result) in
                switch result {
                case .success:
                    DispatchQueue.main.async(execute: {
                        Util.alert(ctrl, message: "저장되었습니다.")
                    })
                    break
                case .error:
                    break
                case .denied:
                    break
                }
            })
        }))
        alert.addAction(UIAlertAction(title:"공유하기",style: .default,handler:{(_) in
            let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
            ctrl.present(vc, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title:"인터넷으로 열기",style: .default,handler:{(_) in
            if let url = Foundation.URL(string: imageUrl){
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:])
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }))
        alert.addAction(UIAlertAction(title:"취소",style: .cancel,handler:nil))
        ctrl.present(alert, animated: false, completion: {(_) in })
    }
    
    
    static func googleMapParse(_ element : [String: AnyObject]) -> (Double, Double, String, String){
        var latitude = 0.0
        var longitude = 0.0
        var addressShort = ""
        var address = ""
        if let latitudeValue = element["latitude"] as? String{
            latitude = Double(latitudeValue)!
        }else if let latitudeValue = element["latitude"] as? Double{
            latitude = latitudeValue
        }
        if let longitudeValue = element["longitude"] as? String{
            longitude = Double(longitudeValue)!
        }else if let longitudeValue = element["longitude"] as? Double{
            longitude = longitudeValue
        }
        if let formattedAddress = element["formattedAddress"] as? String{
            address = formattedAddress
        }
        if let city = element["city"] as? String{
            addressShort = city
        }
        
        
        return (latitude, longitude, addressShort, address)
    }
    
    
    
    typealias Task = (_ cancel : Bool) -> ()
    static func delay(_ time:TimeInterval, task:@escaping ()->() ) ->  Task? {
        func dispatch_later( _ block:@escaping ()->() ) {
            DispatchQueue.main.asyncAfter(
                deadline: DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
                execute: block)
        }
        let closure: ()->()? = task
        var result: Task?
        let delayedClosure: Task = {
            cancel in
            if (cancel == false) {
                DispatchQueue.main.async(execute: closure as! @convention(block) () -> Void)
            }
            result = nil
        }
        result = delayedClosure
        dispatch_later {
            if let delayedClosure = result {
                delayedClosure(false)
            }
        }
        return result
    }
}
