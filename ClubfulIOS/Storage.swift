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
    static var latitude: Double! = 37.551591
    static var longitude: Double! = 126.924975
    
    //스트로지 저장
    static func setStorage(_ key : String, value : AnyObject){
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    //스트로지 꺼내기
    static func getStorage(_ key : String) -> AnyObject?{
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    //스트로지 삭제
    static func removeStorage(_ key : String){
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    
    static func realmMigrationCheck(){
        let config = Realm.Configuration(
            schemaVersion: 5,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 4) {
                    migration.enumerateObjects(ofType: User.className()) { oldObject, newObject in
                        
                    }
                }
        })
        Realm.Configuration.defaultConfiguration = config
        let _ = try! Realm()
    }
    
    //realm user 저장
    static func setRealmUser(_ user : User){
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    //realm user 불러오기
    static func getRealmUserData() -> User{
        let realm = try! Realm()
        if let user : User = realm.objects(User.self).first{
            return user
        }else{
            let user = User()
            try! realm.write{
                realm.add(user)
            }
            return user
        }
    }
    
    //유저 복사(reaml에 저장하기 전)
    static func getRealmUser() -> User{
        let realmUser = Storage.getRealmUserData()
        let user = User()
        user.search = realmUser.search
        user.id = realmUser.id
        user.gcmId = realmUser.gcmId
        user.userId = realmUser.userId
        user.isLogin = realmUser.isLogin
        user.nickName = realmUser.nickName
        user.sex = realmUser.sex
        user.token = realmUser.token
        user.birth = realmUser.birth
        user.userLatitude = realmUser.userLatitude
        user.userLongitude = realmUser.userLongitude
        user.userAddress = realmUser.userAddress
        user.userAddressShort = realmUser.userAddressShort
        
        user.latitude = realmUser.latitude
        user.longitude = realmUser.longitude
        user.address = realmUser.address
        user.addressShort = realmUser.addressShort
        user.noticePushCheck = realmUser.noticePushCheck
        user.myCourtPushCheck = realmUser.myCourtPushCheck
        user.distancePushCheck = realmUser.distancePushCheck
        user.interestPushCheck = realmUser.interestPushCheck
        user.startPushTime = realmUser.startPushTime
        user.endPushTime = realmUser.endPushTime
        user.language = realmUser.language
        user.categoryVer = realmUser.categoryVer
        user.noticeVer = realmUser.noticeVer
        user.category = realmUser.category
        user.categoryName = realmUser.categoryName
        return user
    }
    
    static func locationThread(_ ctrl: UIViewController){
        DispatchQueue.global().async {
            while(true){
                let user = Storage.getRealmUser()
                let param: [String: AnyObject] = ["token": user.token as AnyObject, "latitude": Storage.latitude as AnyObject, "longitude": Storage.longitude as AnyObject]
                URL.request(ctrl, url: URL.apiServer+URL.api_location_user, param: param)
                sleep(300)
            }
        }
    }
}
