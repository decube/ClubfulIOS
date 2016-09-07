//
//  AppDelegate.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    //앱 오픈시 내위치변수
    var vcMyLocationMove = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        //firebase
        FIRApp.configure()
        
        //adobe
        AdobeUXAuthManager.sharedManager().setAuthenticationParametersWithClientID("659e033bb5c94a3fb4965a7a3fed10bb", withClientSecret: "84709325-ecf1-48a4-a3e7-9776950e7129")
        
        //facebook
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
    }
    
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        //kakao
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpenURL(url)
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        //kakao
        if KOSession.isKakaoAccountLoginCallback(url) {
            return KOSession.handleOpenURL(url)
        }
        return false
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        //생명주기 앱살아났을때
        
        //지금 최신 위치 이동
        vcMyLocationMove = true
        
        //앱 통신
        var user = Storage.getRealmUser()
        let parameters : [String: AnyObject] = ["appType": "ios", "appVersion": Util.nsVersion, "deviceCD": NSDate().getFullDate(), "language": Util.language, "deviceId": Util.deviceId, "token": user.token, "categoryVer": user.categoryVer, "noticeVer": user.noticeVer]
        URL.request((self.window?.rootViewController)!, url: URL.version_Check, param: parameters, callback: { (dic) in
            user = Storage.copyUser()
            user.token = dic["token"] as! String
            Util.newVersion = dic["iosVersion"] as! String
            user.categoryVer = dic["categoryVer"] as! Int
            user.noticeVer = dic["noticeVer"] as! Int
            if let categoryList = dic["categoryList"] as? [[String: AnyObject]]{
                Storage.setStorage("categoryList", value: categoryList)
            }
            Storage.setRealmUser(user)
        })
    }
}