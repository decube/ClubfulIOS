//
//  Storage.swift
//  Jundan
//
//  Created by guanho on 2016. 4. 8..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Storage{
    //스트로지 저장
    static func setStorage(key : String, value : AnyObject){
        NSUserDefaults.standardUserDefaults().setObject(value, forKey: key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    //스트로지 꺼내기
    static func getStorage(key : String) -> AnyObject?{
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    //스트로지 삭제
    static func removeStorage(key : String){
        NSUserDefaults.standardUserDefaults().removeObjectForKey(key)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //realm user 저장
    static func setRealmUser(user : User){
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    static func getRealmUser() -> User{
        let realm = try! Realm()
        if let user : User = realm.objects(User).first{
            return user
        }else{
            let user = User()
            try! realm.write{
                realm.add(user)
            }
            return user
        }
    }
    static func copyUser() -> User{
        let realmUser = Storage.getRealmUser()
        let user = User()
        user.address = realmUser.address
        user.addressShort = realmUser.addressShort
        user.distancePushCheck = realmUser.distancePushCheck
        user.endPushTime = realmUser.endPushTime
        user.gcmId = realmUser.gcmId
        user.hp = realmUser.hp
        user.id = realmUser.id
        user.isLogin = realmUser.isLogin
        user.latitude = realmUser.latitude
        user.longitude = realmUser.longitude
        user.myCourtPushCheck = realmUser.myCourtPushCheck
        user.noticePushCheck = realmUser.noticePushCheck
        user.starPushCheck = realmUser.starPushCheck
        user.startPushTime = realmUser.startPushTime
        return user
    }
}