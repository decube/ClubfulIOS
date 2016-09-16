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
    static let urlCheck = "https://clubfulstaticserver-guanho.c9users.io/urlCheck.json"
    
    static var appServer = ""
    static var imageServer = ""
    static var courtUpload = ""
    
    static let version_check = URL.appServer+"version/check_success.json";
    static let version_app = URL.appServer+"version/app_success.json";
    
    static let court_create = URL.appServer+"court/create_success.json";
    static let court_detail = URL.appServer+"court/detail_success.json";
    static let court_interest = URL.appServer+"court/interest_success.json";
    static let court_listSearch = URL.appServer+"court/listSearch_success.json";
    static let court_replyInsert = URL.appServer+"court/replyInsert_success.json";
    
    static let location_geocode = URL.appServer+"location/geocode_success.json";
    
    static let user_join = URL.appServer+"user/join_success.json";
    static let user_login = URL.appServer+"user/login_success.json";
    static let user_logout = URL.appServer+"user/logout_success.json";
    static let user_mypage = URL.appServer+"user/mypage_success.json";
    static let user_set = URL.appServer+"user/set_success.json";
    static let user_update = URL.appServer+"user/update_success.json";
    
    static func request(ctrl: UIViewController, url: String, param: [String: AnyObject], callback: (([String:AnyObject])-> Void)! = nil, codeErrorCallback: (([String:AnyObject])-> Void)! = nil){
        Alamofire.request(.GET, url, parameters: param)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data!
                let dic = Util.convertStringToDictionary(data)
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
        let parameters : [String: AnyObject] = ["appType": "ios", "appVersion": Util.nsVersion, "sendDate": NSDate().getFullDate(), "language": Util.language, "deviceId": Util.deviceId, "token": user.token, "categoryVer": user.categoryVer, "noticeVer": user.noticeVer]
        return parameters
    }
}