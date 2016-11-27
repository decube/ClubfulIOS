//
//  Address.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 26..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation

class Address {
    var data: [String: AnyObject]!
    
    var latitude: Double!
    var longitude: Double!
    var address: String!
    var addressShort: String!
    
    init(_ data: [String: AnyObject]) {
        self.data = data
        self.latitude = getDouble(data["latitude"])
        self.longitude = getDouble(data["longitude"])
        self.address = getString(data["address"])
        self.addressShort = getString(data["addressShort"])
    }
    init(latitude: Double, longitude: Double, address: String, addressShort: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.address = address
        self.addressShort = addressShort
    }
    init() {
    }
    
    func getInt(_ key: AnyObject?) -> Int{
        if let value = key as? String{
            return Int(value)!
        }else if let value = key as? Int{
            return value
        }else{
            return 0
        }
    }
    func getString(_ key: AnyObject?) -> String{
        if let value = key as? String{
            return value
        }else{
            return ""
        }
    }
    func getDouble(_ key: AnyObject?) -> Double{
        if let value = key as? String{
            return Double(value)!
        }else if let value = key as? Double{
            return value
        }else{
            return 0
        }
    }
}
