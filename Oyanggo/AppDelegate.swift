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
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return KOSession.handleOpenURL(url)
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return KOSession.handleOpenURL(url)
    }
    
    
    func applicationDidBecomeActive(application: UIApplication) {
        //생명주기 앱살아났을때
        vcMyLocationMove = true
    }
}

