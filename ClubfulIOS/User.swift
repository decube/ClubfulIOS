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
    
    
    ///////////유저 정보
    //id
    dynamic var userId : String = ""
    //로그인여부
    dynamic var loginType : String = ""
    //닉네임
    dynamic var nickName : String = ""
    //성별
    dynamic var sex : String = ""
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
