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
    dynamic var id = 0
    dynamic var hp : String = ""
    dynamic var isLogin : Int = -1
    dynamic var latitude : Double =  37.5571274
    dynamic var longitude : Double =  126.9239304
    dynamic var address : String = "홍대길게길게"
    dynamic var addressShort : String = "홍대"
    dynamic var noticePushCheck : Bool = true
    dynamic var myCourtPushCheck : Bool = true
    dynamic var distancePushCheck : Bool = true
    dynamic var starPushCheck : Bool = true
    dynamic var startPushTime : NSDate = NSDate()
    dynamic var endPushTime : NSDate = NSDate()
    dynamic var gcmId : String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
