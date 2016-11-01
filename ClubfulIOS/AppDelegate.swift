//
//  AppDelegate.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 9. 26..
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
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //firebase
        FIRApp.configure()
        
        //adobe
        AdobeUXAuthManager.shared().setAuthenticationParametersWithClientID("659e033bb5c94a3fb4965a7a3fed10bb", withClientSecret: "84709325-ecf1-48a4-a3e7-9776950e7129")
        
        //facebook
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions:launchOptions)
    }
    
    func application(_ app: UIApplication, openURL url: NSURL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if KOSession.isKakaoAccountLoginCallback(url.absoluteURL) {
            return KOSession.handleOpen(url.absoluteURL)
        }
        
        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        return FBSDKApplicationDelegate.sharedInstance().application(app, open: url.absoluteURL, sourceApplication: sourceApplication, annotation: nil)
    }

    func application(_ application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: Any) -> Bool {
        if KOSession.isKakaoLinkCallback(url.absoluteURL) {
            return true
        }
        return false
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //앱 통신
        let parameters = URL.vesion_checkParam()
        URL.request((self.window?.rootViewController)!, url: URL.apiServer+URL.api_version_check, param: parameters, callback: { (dic) in
            let user = Storage.getRealmUser()
            user.token = dic["token"] as! String
            Util.newVersion = dic["ver"] as! String
            user.categoryVer = dic["categoryVer"] as! Int
            user.noticeVer = dic["noticeVer"] as! Int
            if let categoryList = dic["categoryList"] as? [[String: AnyObject]]{
                Storage.setStorage("categoryList", value: categoryList as AnyObject)
            }
            Storage.setRealmUser(user)
        })
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //생명주기 앱살아났을때
        
        FBSDKAppEvents.activateApp()
        KOSession.handleDidBecomeActive()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

