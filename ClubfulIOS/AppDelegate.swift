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
import UserNotifications
import FirebaseInstanceID
import FirebaseMessaging

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    static var vc: UIViewController!
    
    func removeCache(){
        //cache지우기
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }
    
    func shortcutCreate(){
        UIApplication.shared.shortcutItems? = []
        if Storage.isRealmUser(){
            UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "home", localizedTitle: "홈", localizedSubtitle: "홈을 보여줍니다", icon: UIApplicationShortcutIcon(templateImageName: "tab_home"), userInfo: nil))
            UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "create", localizedTitle: "등록", localizedSubtitle: "코트를 등록합니다", icon: UIApplicationShortcutIcon(templateImageName: "tab_add"), userInfo: nil))
            UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "user", localizedTitle: "내정보", localizedSubtitle: "내정보를 보여줍니다", icon: UIApplicationShortcutIcon(templateImageName: "tab_mypage"), userInfo: nil))
            UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "setting", localizedTitle: "앱설정", localizedSubtitle: "PUSH등의 설정을 봅니다", icon: UIApplicationShortcutIcon(templateImageName: "tab_setting"), userInfo: nil))
        }else{
            UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "home", localizedTitle: "홈", localizedSubtitle: "홈을 보여줍니다", icon: UIApplicationShortcutIcon(templateImageName: "tab_home"), userInfo: nil))
            UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "login", localizedTitle: "로그인", localizedSubtitle: "로그인 화면으로 이동합니다", icon: UIApplicationShortcutIcon(templateImageName: "ic_login"), userInfo: nil))
            UIApplication.shared.shortcutItems?.append(UIMutableApplicationShortcutItem(type: "setting", localizedTitle: "앱설정", localizedSubtitle: "PUSH등의 설정을 봅니다", icon: UIApplicationShortcutIcon(templateImageName: "tab_setting"), userInfo: nil))
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Storage.realmMigrationCheck()
        //self.removeCache()
        
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        
        let attributes: [String: AnyObject] = [NSFontAttributeName:UIFont(name: "BradleyHandITCTT-Bold", size: 11)!]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
        
        //push
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions,completionHandler: {_, _ in })
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        application.registerForRemoteNotifications()
        
        shortcutCreate()
        
        //firebase
        FIRApp.configure()
        
        //push
        NotificationCenter.default.addObserver(self,selector: #selector(self.tokenRefreshNotification),name: .firInstanceIDTokenRefresh,object: nil)
        
        
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
    
    func returnTabbar(shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void){
        if self.window?.rootViewController?.presentedViewController != nil{
            self.window?.rootViewController?.presentedViewController?.dismiss(animated: false, completion: {
                self.returnTabbar(shortcutItem: shortcutItem, completionHandler: completionHandler)
            })
        }else{
            if self.window?.rootViewController?.presentedViewController == nil{
                let tabbar = self.window?.rootViewController?.tabBarController?.tabBar
                if shortcutItem.type == "home"{
                    tabbar?.tag = 0
                    tabbar?.tag = 0
                }else if shortcutItem.type == "create"{
                    tabbar?.tag = 1
                }else if shortcutItem.type == "user"{
                    tabbar?.tag = 2
                    tabbar?.tag = 2
                }else if shortcutItem.type == "setting"{
                    tabbar?.tag = 3
                    AppDelegate.vc.performSegue(withIdentifier: "set_appSetting", sender: nil)
                }else if shortcutItem.type == "login"{
                    tabbar?.tag = 3
                    AppDelegate.vc.performSegue(withIdentifier: "set_login", sender: nil)
                }
            }
            completionHandler(true)
        }
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        returnTabbar(shortcutItem: shortcutItem, completionHandler: completionHandler)
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        //생명주기 앱이 백그라운드가 됬을때
        //push
        FIRMessaging.messaging().disconnect()
        shortcutCreate()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        //앱 통신
        let deviceUser = Storage.getRealmDeviceUser()
        var parameters : [String: AnyObject] = [:]
        parameters.updateValue("ios" as AnyObject, forKey: "appType")
        parameters.updateValue(Util.nsVersion as AnyObject, forKey: "appVersion")
        parameters.updateValue(Date().getFullDate() as AnyObject, forKey: "sendDate")
        parameters.updateValue(Util.language as AnyObject, forKey: "language")
        parameters.updateValue(Util.deviceId as AnyObject, forKey: "deviceId")
        parameters.updateValue(deviceUser.categoryVer as AnyObject, forKey: "categoryVer")
        parameters.updateValue(deviceUser.noticeVer as AnyObject, forKey: "noticeVer")
        
        URLReq.request((self.window?.rootViewController)!, url: URLReq.apiServer+"version/check", param: parameters, callback: { (dic) in
            let deviceUser = Storage.getRealmDeviceUser()
            if let token = dic["token"] as? String{
                deviceUser.token = token
            }
            if let ver = dic["ver"] as? String{
                Util.newVersion = ver
            }
            if let categoryVer = dic["categoryVer"] as? String{
                deviceUser.categoryVer = Int(categoryVer)!
            }
            if let noticeVer = dic["noticeVer"] as? String{
                deviceUser.noticeVer = Int(noticeVer)!
            }
            if let categoryList = dic["categoryList"] as? [[String: AnyObject]]{
                Storage.setStorage("categoryList", value: categoryList as AnyObject)
            }
            Storage.setRealmDeviceUser(deviceUser)
        })
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //생명주기 앱살아났을때
        
        //fb
        FBSDKAppEvents.activateApp()
        //kakao
        KOSession.handleDidBecomeActive()
        //push
        connectToFcm()
        
        shortcutCreate()
    }
    
    
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        receivedPushMessage(push: userInfo)
    }
    // [END receive_message]
    // [START refresh_token]
    func tokenRefreshNotification(_ notification: Notification) {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("tokenRefreshNotification InstanceID token: \(refreshedToken)")
            let deviceUser = Storage.getRealmDeviceUser()
            deviceUser.pushID = refreshedToken
            Storage.setRealmDeviceUser(deviceUser)
        }
        // Connect to FCM since connection may have failed when attempted before having a token.
        connectToFcm()
    }
    // [END refresh_token]
    // [START connect_to_fcm]
    func connectToFcm() {
        FIRMessaging.messaging().connect { (error) in
            if error != nil {
                print("connectToFcm Unable to connect with FCM. \(error)")
            } else {
                print("connectToFcm Connected to FCM.")
            }
        }
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func receivedPushMessage(push: [AnyHashable: Any]){
        if let type = push["type"] as? String{
            if type == "call" || type == "accept"{
                var date = ""
                var seq = 0
                var memberSeq = 0
                if let dateReg = push["date"] as? String{
                    date = dateReg
                }
                if let seqReg = push["seq"] as? String{
                    seq = Int(seqReg)!
                }
                if let memberSeqReg = push["memberSeq"] as? String{
                    memberSeq = Int(memberSeqReg)!
                }
                print("date: \(date), seq: \(seq), memberSeq: \(memberSeq)")
                if type == "call"{
                    let currentDate = Date().getDate()
                    if currentDate == date.substring(from: 0, length: 10){
                        if Date().hour() == date.substring(from: 11, length: 2){
                            _ = Util.alert((self.window?.rootViewController)!, message: "코트 초대에 응하시겠습니까?", confirmTitle: "수락", cancelStr: "거절", isCancel: true, confirmHandler: { (_) in
                                
                            })
                        }else{
                            _ = Util.alert((self.window?.rootViewController)!, message: "이미 지나간 알림입니다.")
                        }
                    }else{
                        _ = Util.alert((self.window?.rootViewController)!, message: "이미 지나간 알림입니다.")
                    }
                }else if type == "accept"{
                    _ = Util.alert((self.window?.rootViewController)!, message: "회원님의 호출에 누구누구님이 승낙을 하였습니다.")
                }
            }
        }
    }
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        receivedPushMessage(push: userInfo)
    }
}
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print("%@", remoteMessage.appData)
    }
}



class AppShortcut : UIMutableApplicationShortcutItem {
    var segue:String
    
    init(type:String, title:String, icon:String, segue:String) {
        self.segue = segue
        let translatedTitle = NSLocalizedString(title, comment:title)
        let iconImage = UIApplicationShortcutIcon(templateImageName: icon)
        super.init(type: type, localizedTitle:translatedTitle, localizedSubtitle:nil, icon:iconImage, userInfo:nil)
    }
}
