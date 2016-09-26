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
    
    //realm user 저장
    static func setRealmUser(_ user : User){
        let realm = try! Realm()
        try! realm.write {
            realm.add(user, update: true)
        }
    }
    //realm user 불러오기
    static func getRealmUser(_ isFirst : Bool = true) -> User{
        let realm = try! Realm()
        if let user : User = realm.objects(User.self).first{
            if isFirst == true{
                return isUserInit(user)
            }else{
                return user
            }
        }else{
            let user = User()
            try! realm.write{
                realm.add(user)
            }
            if isFirst == true{
                return isUserInit(user)
            }else{
                return user
            }
        }
    }
    
    //init 유저언어가 바뀌거나 언어가 없을때 초기화
    static func isUserInit(_ user: User) -> User{
        if user.language == "" || user.language != Util.language{
            let userTmp = Storage.copyUser(false)
            userTmp.userId = ""
            userTmp.isLogin = -1
            userTmp.nickName = ""
            userTmp.sex = ""
            userTmp.token = ""
            userTmp.birth = Date()
            userTmp.userLatitude = 37.5571274
            userTmp.userLongitude = 126.9239304
            userTmp.userAddress = "홍대길게길게"
            userTmp.userAddressShort = "홍대"
            
            userTmp.latitude = 37.5571274
            userTmp.longitude = 126.9239304
            userTmp.address = "홍대길게길게"
            userTmp.addressShort = "홍대"
            userTmp.noticePushCheck = true
            userTmp.myCourtPushCheck = true
            userTmp.distancePushCheck = true
            userTmp.interestPushCheck = true
            userTmp.startPushTime = Date()
            userTmp.endPushTime = Date()
            userTmp.language = Util.language
            userTmp.categoryVer = -1
            userTmp.noticeVer = -1
            userTmp.category = -1
            userTmp.categoryName = "전체"
            
            Storage.setRealmUser(userTmp)
            return userTmp
        }else{
            return user
        }
    }
    
    //유저 복사(reaml에 저장하기 전)
    static func copyUser(_ isFirst : Bool = true) -> User{
        let realmUser = Storage.getRealmUser(isFirst)
        let user = User()
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
