//
//  DeviceUser.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 2..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class DeviceUser: Object{
    //primaryKey
    dynamic var id = 0
    
    //gcmId
    dynamic var gcmId : String = ""
    //token
    dynamic var token : String = ""
    //search
    dynamic var search : String = ""
    
    //위도
    dynamic var latitude : Double =  0.0
    //경도
    dynamic var longitude : Double =  0.0
    //주소
    dynamic var address : String = ""
    //주소short
    dynamic var addressShort : String = ""
    //공지푸시체크
    dynamic var noticePushCheck : Bool = true
    //내가등록한코트푸시체크
    dynamic var myCourtPushCheck : Bool = true
    //거리푸시체크
    dynamic var distancePushCheck : Bool = true
    //관심푸시체크
    dynamic var interestPushCheck : Bool = true
    //푸시제한시작시간
    dynamic var startPushTime : Date = Date()
    //푸시제한종료시간
    dynamic var endPushTime : Date = Date()
    //language
    dynamic var language : String = ""
    //categoryVer
    dynamic var categoryVer : Int = -1
    //noticeVer
    dynamic var noticeVer : Int = -1
    //category
    dynamic var category : Int = -1
    //categoryName
    dynamic var categoryName : String = "전체"
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
