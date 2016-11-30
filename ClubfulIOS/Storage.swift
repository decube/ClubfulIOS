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
            schemaVersion: 8,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 7) {
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
    static func getRealmUserData() -> User!{
        let realm = try! Realm()
        if let user : User = realm.objects(User.self).first{
            return user
        }else{
            return nil
        }
    }
    
    //유저 복사(reaml에 저장하기 전)
    static func getRealmUser() -> User{
        let realmUser = Storage.getRealmUserData()
        if realmUser == nil{
            return User()
        }else{
            let user = User()
            user.id = (realmUser?.id)!
            user.userId = (realmUser?.userId)!
            user.loginType = (realmUser?.loginType)!
            user.nickName = (realmUser?.nickName)!
            user.sex = (realmUser?.sex)!
            user.birth = (realmUser?.birth)!
            user.userLatitude = (realmUser?.userLatitude)!
            user.userLongitude = (realmUser?.userLongitude)!
            user.userAddress = (realmUser?.userAddress)!
            user.userAddressShort = (realmUser?.userAddressShort)!
            
            return user
        }
    }
    //realm user 지우기
    static func removeReamlUserData(){
        let realm = try! Realm()
        if let user : User = realm.objects(User.self).first{
            try! realm.write {
                realm.delete(user)
            }
        }
    }
    //realm user Data 검사
    static func isRealmUser() -> Bool{
        let realm = try! Realm()
        if let user = realm.objects(User.self).first{
            if user.userId == "" || user.loginType == ""{
                return false
            }else{
                return true
            }
        }else{
            return false
        }
    }
    
    //realm deviceUser 저장
    static func setRealmDeviceUser(_ deviceUser : DeviceUser){
        let realm = try! Realm()
        try! realm.write {
            realm.add(deviceUser, update: true)
        }
    }
    //realm deviceUserData 불러오기
    static func getRealmDeviceUserData() -> DeviceUser{
        let realm = try! Realm()
        if let deviceUser : DeviceUser = realm.objects(DeviceUser.self).first{
            return deviceUser
        }else{
            let deviceUser = DeviceUser()
            //deviceUser.language = Util.language
            try! realm.write{
                realm.add(deviceUser)
            }
            return deviceUser
        }
    }
    //realm deviceUser 불러오기
    static func getRealmDeviceUser() -> DeviceUser{
        let realmDevice = Storage.getRealmDeviceUserData()
        let device = DeviceUser()
        device.id = realmDevice.id
        device.pushID = realmDevice.pushID
        device.token = realmDevice.token
        device.search = realmDevice.search
        device.latitude = realmDevice.latitude
        device.longitude = realmDevice.longitude
        device.address = realmDevice.address
        device.addressShort = realmDevice.addressShort
        device.noticePushCheck = realmDevice.noticePushCheck
        device.myCourtPushCheck = realmDevice.myCourtPushCheck
        device.distancePushCheck = realmDevice.distancePushCheck
        device.interestPushCheck = realmDevice.interestPushCheck
        device.startPushTime = realmDevice.startPushTime
        device.endPushTime = realmDevice.endPushTime
        device.language = realmDevice.language
        device.categoryVer = realmDevice.categoryVer
        device.noticeVer = realmDevice.noticeVer
        device.category = realmDevice.category
        device.categoryName = realmDevice.categoryName
        device.deviceLatitude = realmDevice.deviceLatitude
        device.deviceLongitude = realmDevice.deviceLongitude
        device.isMyLocation = realmDevice.isMyLocation
        
        return device
    }
    
    
    
    
    static func locationThread(_ ctrl: UIViewController){
        DispatchQueue.global().async {
            while(true){
                let param: [String: AnyObject] = ["latitude": Storage.latitude as AnyObject, "longitude": Storage.longitude as AnyObject]
                URLReq.request(ctrl, url: URLReq.apiServer+URLReq.api_location_user, param: param)
                Thread.sleep(forTimeInterval: 1)
            }
        }
    }
}
