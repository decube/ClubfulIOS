//
//  URL.swift
//  Oyanggo
//
//  Created by guanho on 2016. 7. 24..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import Alamofire

class URLReq{
    static let urlCheck = "https://decubestaticserver-guanho.c9users.io/clubful_url.json"
    
    static var apiServer = "https://clubful-smkim89.c9users.io/"
    static var imageServer = "https://decubeimageserver-guanho.c9users.io/"
    static var viewServer = ""
    
    
    static var courtUpload = URLReq.imageServer+"upload/clubful/court/"
    static var courtDownload = URLReq.imageServer+"download/clubful/court/"
    
    
    
    static var view_info = "/view_info"
    static var view_notice = "/view_notice"
    static var view_guide = "/view_guide"
    static var view_inquiry = "/view_inquiry"
    
    static var api_court_interest = "/api_court_interest"
    static var api_court_replyInsert = "/api_court_replyInsert"////////////
    static var api_user_mypage = "/api_user_mypage"
    static var api_user_update = "/api_user_update"
    
    static func request(_ ctrl: UIViewController, url: String, param: [String: AnyObject], callback: (([String:AnyObject])-> Void)! = nil, codeErrorCallback: (([String:AnyObject])-> Void)! = nil){
        let deviceUser = Storage.getRealmDeviceUser()
        var paramValue = param
        paramValue.updateValue(deviceUser.token as AnyObject, forKey: "token")
        Alamofire.request(url, method: .post, parameters: paramValue)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data! as NSData
                let dic = Util.convertStringToDictionary(data as Data)
                URLReq.log(url: url, param: paramValue, response: response, dic: dic)
                if let code = dic["code"] as? Int{
                    if code == 0{
                        if callback != nil{
                            callback(dic)
                        }
                    }else{
                        if let isMsgView = dic["isMsgView"] as? Bool{
                            if isMsgView == true{
                                Util.alert(ctrl, message: "\(dic["msg"]!)")
                            }
                        }
                        if codeErrorCallback != nil{
                            codeErrorCallback(dic)
                        }
                    }
                }
            }
    }
    
    static func log(url: String, param: [String: AnyObject], response: DataResponse<Data>, dic: [String: AnyObject]){
        print("\r\n@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
        print(":::url:::\(url)")
        print("----------------------------------------------------------------------")
        print(":::param:::\(param)")
        print("----------------------------------------------------------------------")
        if let dataValue = response.data{
            print(":::response:::\(String(data: dataValue, encoding: String.Encoding.utf8))")
        }
        print("----------------------------------------------------------------------")
        print(":::dic:::\(dic)")
        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@\r\n")
    }
    
        
    
//    ///////////////////
//    //GET Async 동기 통신
//    ///////////////////
//    static func initApiRequest(_ ctrl: UIViewController, callback: ((Void) -> Void)!){
//        var request : NSMutableURLRequest
//        let apiUrl = Foundation.URL(string: URLReq.urlCheck)
//        request = NSMutableURLRequest(url: apiUrl!)
//        request.httpMethod = "GET"
//        var data = Data()
//        let semaphore = DispatchSemaphore(value: 0)
//        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(responseData,_,_) -> Void in
//            if responseData != nil{
//                data = responseData!
//            }
//            semaphore.signal()
//        }).resume()
//        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
//        do{
//            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
//            URLReq.apiServer = json["apiServer"] as! String
//            URLReq.viewServer = json["viewServer"] as! String
//            URLReq.courtUpload = json["courtUpload"] as! String
//            
//            URLReq.view_info = json["view_info"] as! String
//            URLReq.view_notice = json["view_notice"] as! String
//            URLReq.view_guide = json["view_guide"] as! String
//            URLReq.view_inquiry = json["view_inquiry"] as! String
//            
//            URLReq.api_version_check = json["api_version_check"] as! String
//            URLReq.api_version_app = json["api_version_app"] as! String
//            URLReq.api_court_create = json["api_court_create"] as! String
//            URLReq.api_court_detail = json["api_court_detail"] as! String
//            URLReq.api_court_interest = json["api_court_interest"] as! String
//            URLReq.api_court_listSearch = json["api_court_listSearch"] as! String
//            URLReq.api_court_replyInsert = json["api_court_replyInsert"] as! String
//            URLReq.api_location_geocode = json["api_location_geocode"] as! String
//            URLReq.api_location_user = json["api_location_user"] as! String
//            URLReq.api_user_join = json["api_user_join"] as! String
//            URLReq.api_user_login = json["api_user_login"] as! String
//            URLReq.api_user_logout = json["api_user_logout"] as! String
//            URLReq.api_user_mypage = json["api_user_mypage"] as! String
//            URLReq.api_user_set = json["api_user_set"] as! String
//            URLReq.api_user_update = json["api_user_update"] as! String
//            URLReq.api_user_info = json["api_user_info"] as! String
//            
//            if callback != nil{
//                callback()
//            }
//        } catch _ as NSError {}
//    }
}
