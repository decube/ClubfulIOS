//
//  User.swift
//  Oyanggo
//
//  Created by guanho on 2016. 6. 20..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation
import RealmSwift

class User: Object {
    //primaryKey
    dynamic var id = 0
    
    
    //gcmId
    dynamic var gcmId : String = ""
    
    
    
    ///////////유저 정보
    //id
    dynamic var userId : String = ""
    //로그인여부
    dynamic var isLogin : Int = -1
    //닉네임
    dynamic var nickName : String = ""
    //성별
    dynamic var sex : String = ""
    //token
    dynamic var token : String = ""
    //생년월일
    dynamic var birth : Date = Date()
    //위도
    dynamic var userLatitude : Double =  0.0
    //경도
    dynamic var userLongitude : Double =  0.0
    //주소
    dynamic var userAddress : String = ""
    //주소short
    dynamic var userAddressShort : String = ""
    
    
    ///////////디바이스 정보
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
