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
}
