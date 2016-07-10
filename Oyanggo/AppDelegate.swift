//
//  AppDelegate.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //앱 오픈시 내위치변수
    var vcMyLocationMove = false
    
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if let dic = userInfo["aps"] as? NSDictionary {
            let message: String = dic["alert"] as! String
            print("message=\(message)")
        }
    }
    
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return KOSession.handleOpenURL(url)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("didRegisterForRemoteNotificationsWithDeviceToken=\(deviceToken)")
    }
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("didFailToRegisterForRemoteNotificationsWithError=\(error.localizedDescription)")
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        print("?3333")
        return KOSession.handleOpenURL(url)
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        //생명주기 앱살아났을때
        vcMyLocationMove = true
    }
}

