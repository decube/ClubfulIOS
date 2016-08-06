//
//  AppDelegate.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //앱 오픈시 내위치변수
    var vcMyLocationMove = false
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return KOSession.handleOpenURL(url)
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return KOSession.handleOpenURL(url)
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        //생명주기 앱살아났을때
        
        //지금 최신 위치 이동
        vcMyLocationMove = true
        
        
        //앱 통신
        var user = Storage.getRealmUser()
        let parameters : [String: AnyObject] = ["appType": "ios", "appVersion": Util.nsVersion, "deviceCD": NSDate().getFullDate(), "language": Util.language, "deviceId": Util.deviceId, "token": user.token, "categoryVer": user.categoryVer, "noticeVer": user.noticeVer]
        Alamofire.request(.GET, URL.version_Check, parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                let data : NSData = response.data!
                let dic = Util.convertStringToDictionary(data)
                if let code = dic["code"] as? Int{
                    if code == 0{
                        user = Storage.copyUser()
                        user.token = dic["token"] as! String
                        Util.newVersion = dic["iosVersion"] as! String
                        user.categoryVer = dic["categoryVer"] as! Int
                        user.noticeVer = dic["noticeVer"] as! Int
                        if let categoryList = dic["categoryList"] as? [[String: AnyObject]]{
                            Storage.setStorage("categoryList", value: categoryList)
                        }
                        Storage.setRealmUser(user)
                    }
                }
        }
        
        
        
        
        
        
        
        
        
    }
}

