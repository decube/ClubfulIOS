//
//  Court.swift
//  ClubfulIOS
//
//  Created by guanho on 2016. 11. 24..
//  Copyright © 2016년 guanho. All rights reserved.
//

import Foundation

class Court {
    var data: [String: AnyObject]!
    
    var seq: Int!
    var categorySeq: Int!
    var categoryName: String!
    var address: String!
    var addressShort: String!
    var cname: String!
    var latitude: Double!
    var longitude: Double!
    var description: String!
    var makeDT: String!
    var updateDT: String!
    var interest: Int!
    var image: String!
    var imageList: [[String: String]]!
    
    init(_ data: [String: AnyObject]) {
        self.data = data
        self.seq = getInt(data["seq"])
        self.categorySeq = getInt(data["categorySeq"])
        self.categoryName = getString(data["categoryName"])
        self.address = getString(data["address"])
        self.addressShort = getString(data["addressShort"])
        self.cname = getString(data["cname"])
        self.latitude = getDouble(data["latitude"])
        self.longitude = getDouble(data["longitude"])
        self.description = getString(data["description"])
        self.makeDT = getString(data["makeDT"])
        self.updateDT = getString(data["updateDT"])
        self.image = getString(data["image"])
        self.interest = getInt(data["interest"])
        self.imageList = getArrayString("imageList", inner: ["image"])
        if self.imageList.count != 0{
            self.image = self.imageList.first?["image"]
        }
    }
    init() {
    }
    
    func getArrayString(_ key: String, inner: [String]) -> [[String: String]]{
        if let value = data["\(key)"] as? [[String: AnyObject]]{
            var tmpArray : [[String: String]] = [[String: String]]()
            for element in value{
                var innerElement : [String: String] = [String: String]()
                for innerKey in inner{
                    innerElement.updateValue(getString(element[innerKey]), forKey: innerKey)
                }
                tmpArray.append(innerElement)
            }
            return tmpArray
        }else{
            return [[String: String]]()
        }
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
