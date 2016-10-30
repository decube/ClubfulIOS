//
//  URL.swift
//  Oyanggo
//
//  Created by guanho on 2016. 7. 24..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import Alamofire

class URL{
    static let urlCheck = "https://decubestaticserver-guanho.c9users.io/clubful_url.json"
    
    static var apiServer = ""
    static var viewServer = ""
    static var courtUpload = ""
    
    static var view_info = ""
    static var view_notice = ""
    static var view_guide = ""
    static var view_inquiry = ""
    
    static var api_version_check = ""
    static var api_version_app = ""
    static var api_court_create = ""
    static var api_court_detail = ""
    static var api_court_interest = ""
    static var api_court_listSearch = ""
    static var api_court_replyInsert = ""
    static var api_location_geocode = ""
    static var api_location_user = ""
    static var api_user_join = ""
    static var api_user_login = ""
    static var api_user_logout = ""
    static var api_user_mypage = ""
    static var api_user_set = ""
    static var api_user_update = ""
    static var api_user_info = ""
    
    static func request(_ ctrl: UIViewController, url: String, param: [String: AnyObject], callback: (([String:AnyObject])-> Void)! = nil, codeErrorCallback: (([String:AnyObject])-> Void)! = nil){
        Alamofire.request(url, method: .get, parameters: param)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data! as NSData
                let dic = Util.convertStringToDictionary(data as Data)
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
    
    static func vesion_checkParam() -> [String: AnyObject]{
        let user = Storage.getRealmUser()
        let parameters = ["appType": "ios" as AnyObject, "appVersion": Util.nsVersion as AnyObject, "sendDate": Date().getFullDate() as AnyObject, "language": Util.language as AnyObject, "deviceId": Util.deviceId as AnyObject, "token": user.token as AnyObject, "categoryVer": user.categoryVer as AnyObject, "noticeVer": user.noticeVer as AnyObject]
        return parameters
    }
    
    
    
    
    ///////////////////
    //GET Async 동기 통신
    ///////////////////
    static func initApiRequest(_ ctrl: UIViewController){
        var request : NSMutableURLRequest
        let apiUrl = Foundation.URL(string: URL.urlCheck)
        request = NSMutableURLRequest(url: apiUrl!)
        request.httpMethod = "GET"
        var data = Data()
        let semaphore = DispatchSemaphore(value: 0)
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(responseData,_,_) -> Void in
            if responseData != nil{
                data = responseData!
            }
            semaphore.signal()
        }).resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! [String: AnyObject]
            URL.apiServer = json["apiServer"] as! String
            URL.viewServer = json["viewServer"] as! String
            URL.courtUpload = json["courtUpload"] as! String
            
            URL.view_info = json["view_info"] as! String
            URL.view_notice = json["view_notice"] as! String
            URL.view_guide = json["view_guide"] as! String
            URL.view_inquiry = json["view_inquiry"] as! String
            
            URL.api_version_check = json["api_version_check"] as! String
            URL.api_version_app = json["api_version_app"] as! String
            URL.api_court_create = json["api_court_create"] as! String
            URL.api_court_detail = json["api_court_detail"] as! String
            URL.api_court_interest = json["api_court_interest"] as! String
            URL.api_court_listSearch = json["api_court_listSearch"] as! String
            URL.api_court_replyInsert = json["api_court_replyInsert"] as! String
            URL.api_location_geocode = json["api_location_geocode"] as! String
            URL.api_location_user = json["api_location_user"] as! String
            URL.api_user_join = json["api_user_join"] as! String
            URL.api_user_login = json["api_user_login"] as! String
            URL.api_user_logout = json["api_user_logout"] as! String
            URL.api_user_mypage = json["api_user_mypage"] as! String
            URL.api_user_set = json["api_user_set"] as! String
            URL.api_user_update = json["api_user_update"] as! String
            URL.api_user_info = json["api_user_info"] as! String
            
            //버전체크 통신
            let parameters = URL.vesion_checkParam()
            URL.request(ctrl, url: URL.apiServer+URL.api_version_check, param: parameters, callback: { (dic) in
                let user = Storage.copyUser()
                user.token = dic["token"] as! String
                Util.newVersion = dic["ver"] as! String
                user.categoryVer = dic["categoryVer"] as! Int
                user.noticeVer = dic["noticeVer"] as! Int
                if let categoryList = dic["categoryList"] as? [[String: AnyObject]]{
                    Storage.setStorage("categoryList", value: categoryList as AnyObject)
                }
                Storage.setRealmUser(user)
            })
        } catch _ as NSError {}
    }
}
