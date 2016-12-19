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
    var image1: String!
    var image2: String!
    var image3: String!
    var image4: String!
    var image5: String!
    var image6: String!
    var imageData1: Data!
    var imageData2: Data!
    var imageData3: Data!
    var imageData4: Data!
    var imageData5: Data!
    var imageData6: Data!
    
    func callbackFn(_ callback: ((Void) -> Void)!){
        if callback != nil{
            callback()
        }
    }
    func setImage1Data(_ callback: ((Void) -> Void)!){
        if let imgURL = Foundation.URL(string: self.image1){
            if let imgData = try? Data(contentsOf: imgURL){
                self.imageData1 = imgData
                self.callbackFn(callback)
            }else{
                self.callbackFn(callback)
            }
        }else{
            self.callbackFn(callback)
        }
    }
    func setImage2Data(_ callback: ((Void) -> Void)!){
        if let imgURL = Foundation.URL(string: self.image2){
            if let imgData = try? Data(contentsOf: imgURL){
                self.imageData2 = imgData
                self.callbackFn(callback)
            }else{
                self.callbackFn(callback)
            }
        }else{
            self.callbackFn(callback)
        }
    }
    func setImage3Data(_ callback: ((Void) -> Void)!){
        if let imgURL = Foundation.URL(string: self.image3){
            if let imgData = try? Data(contentsOf: imgURL){
                self.imageData3 = imgData
                self.callbackFn(callback)
            }else{
                self.callbackFn(callback)
            }
        }else{
            self.callbackFn(callback)
        }
    }
    func setImage4Data(_ callback: ((Void) -> Void)!){
        if let imgURL = Foundation.URL(string: self.image4){
            if let imgData = try? Data(contentsOf: imgURL){
                self.imageData4 = imgData
                self.callbackFn(callback)
            }else{
                self.callbackFn(callback)
            }
        }else{
            self.callbackFn(callback)
        }
    }
    func setImage5Data(_ callback: ((Void) -> Void)!){
        if let imgURL = Foundation.URL(string: self.image5){
            if let imgData = try? Data(contentsOf: imgURL){
                self.imageData5 = imgData
                self.callbackFn(callback)
            }else{
                self.callbackFn(callback)
            }
        }else{
            self.callbackFn(callback)
        }
    }
    func setImage6Data(_ callback: ((Void) -> Void)!){
        if let imgURL = Foundation.URL(string: self.image6){
            if let imgData = try? Data(contentsOf: imgURL){
                self.imageData6 = imgData
                self.callbackFn(callback)
            }else{
                self.callbackFn(callback)
            }
        }else{
            self.callbackFn(callback)
        }
    }
    
    init(_ data: [String: AnyObject]) {
        self.data = data
        self.seq = getInt(data["seq"])
        self.categorySeq = getInt(data["categorySeq"])
        self.categoryName = getString(data["categoryNM"])
        self.address = getString(data["address"])
        self.addressShort = getString(data["addressShort"])
        self.cname = getString(data["cname"])
        self.latitude = getDouble(data["latitude"])
        self.longitude = getDouble(data["longitude"])
        self.description = getString(data["description"])
        self.makeDT = getString(data["makeDT"])
        self.updateDT = getString(data["updateDT"])
        self.image1 = getString(data["image1"])
        self.image2 = getString(data["image2"])
        self.image3 = getString(data["image3"])
        self.image4 = getString(data["image4"])
        self.image5 = getString(data["image5"])
        self.image6 = getString(data["image6"])
        self.interest = getInt(data["interest"])
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
