//
//  AppDelegate.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 13..
//  Copyright © 2016년 guanho. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    var loginCtrl : LoginViewController!
    //googleAuth
    var credential: FIRAuthCredential!
    
    var window: UIWindow?
    
    //앱 오픈시 내위치변수
    var vcMyLocationMove = false
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
        
        //firebase
        FIRApp.configure()
        
        //google
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()!.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        
        //adobe
        AdobeUXAuthManager.sharedManager().setAuthenticationParametersWithClientID("659e033bb5c94a3fb4965a7a3fed10bb", withClientSecret: "84709325-ecf1-48a4-a3e7-9776950e7129")
        
        return true
    }
    
    
    func application(application: UIApplication,
                     openURL url: NSURL, options: [String: AnyObject]) -> Bool {
        //google
        return GIDSignIn.sharedInstance().handleURL(url,sourceApplication: options[UIApplicationOpenURLOptionsSourceApplicationKey] as? String, annotation: options[UIApplicationOpenURLOptionsAnnotationKey])
    }
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        //google
        let _: [String: AnyObject] = [UIApplicationOpenURLOptionsSourceApplicationKey: sourceApplication!,
                                            UIApplicationOpenURLOptionsAnnotationKey: annotation]
        let googleResult =  GIDSignIn.sharedInstance().handleURL(url, sourceApplication: sourceApplication, annotation: annotation)
        //kakao
        let kakaoResult = KOSession.handleOpenURL(url)
        
        return googleResult || kakaoResult
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        //kakao
        return KOSession.handleOpenURL(url)
    }
    
    
    //google
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        
        let authentication = user.authentication
        let credential = FIRGoogleAuthProvider.credentialWithIDToken(authentication.idToken, accessToken: authentication.accessToken)
        FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            if let user = FIRAuth.auth()?.currentUser {
                self.credential = credential
                let name = user.displayName
                let email = user.email
                //let photoUrl = user.photoURL
                //let uid = user.uid;  // The user's ID, unique to the Firebase project.
                self.loginCtrl.googleActionCallback(email!, name: name!)
            } else {
                // No user is signed in.
            }
        }
    }
    //google
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user:GIDGoogleUser!,
                withError error: NSError!) {
        // Perform any operations when the user disconnects from app here.
        // ...
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

